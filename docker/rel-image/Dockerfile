FROM flow123d/pflotran-gnu-rel:latest as build_cont
# By Pavel Exner <pavel.exner@tul.cz>

ARG source_repository
ARG commit

# create a user
# RUN groupadd -g 999 appuser && \
#     useradd -r -u 999 -g appuser appuser
# USER appuser


# TODO: clean builds and repos, copy to bin

#############################################################
# build LaGriT
WORKDIR ${HOME}/workspace/
RUN git clone https://github.com/lanl/LaGriT.git
WORKDIR ${HOME}/workspace/LaGriT/
RUN git checkout tags/v3.3.2 -b v3.3.2-branch

# build LaGriT - install GFortran 9 (due to error warnings)
# RUN update-alternatives --config gfortran
RUN apt-get update
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get -y install gfortran-9
RUN update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-9 9
RUN update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-11 11
RUN update-alternatives --set gfortran /usr/bin/gfortran-9
RUN gfortran --version

# build LaGriT - could not find -lstdc++
RUN ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so

RUN apt-get -y install libz-dev m4 bison
RUN make help
# RUN make exodus
# RUN make release
RUN make WITH_EXODUS=0 release


# build LaGriT - one test fails without Exodus
RUN ls /workspace/LaGriT/src/lagrit*
# RUN make test
#############################################################

#############################################################
# build FEHM
WORKDIR ${HOME}/workspace/
RUN git clone https://github.com/lanl/FEHM.git
WORKDIR ${HOME}/workspace/FEHM/
RUN git checkout tags/v3.4.0 -b v3.4.0-branch
WORKDIR ${HOME}/workspace/FEHM/src
RUN make all

RUN ls xfehm*
#############################################################

#############################################################
# build dfnWorks
ENV dfnworks_PATH="/workspace/dfnWorks/"

RUN ["pip3","install","setuptools","numpy","h5py","matplotlib","scipy","networkx",\
    "rich","pyvtk","fpdf","rich","seaborn","mplstereonet","mpmath","datetime"]

# from repository
# WORKDIR ${HOME}/workspace/
# RUN git clone ${source_repository}
# WORKDIR ${HOME}/workspace/dfnWorks
# RUN git checkout ${commit}

# from local
RUN mkdir $dfnworks_PATH
WORKDIR $dfnworks_PATH
COPY . .
RUN ["mkdir","bin"]

WORKDIR $dfnworks_PATH/C_stor_correct
RUN ["make","clean"]
RUN ["make"]
RUN ["cp","correct_stor","../bin/correct_stor"]
ENV CORRECT_STOR_EXE="$dfnworks_PATH/bin/correct_stor"

WORKDIR $dfnworks_PATH/C_uge_correct
RUN ["make","clean"]
RUN ["make"]
RUN ["cp","correct_uge","../bin/correct_uge"]
ENV CORRECT_UGE_EXE="/workspace/dfnWorks/bin/correct_uge"

WORKDIR $dfnworks_PATH/DFNGen
RUN ["make","clean"]
RUN ["make","-j","4"]
RUN ["cp","DFNGen","../bin/DFNGen"]
ENV DFNGEN_EXE="/workspace/dfnWorks/bin/DFNGen"

WORKDIR $dfnworks_PATH/DFNTrans
RUN ["make","clean"]
RUN ["make","-j","4"]
RUN ["cp","DFNTrans","../bin/DFNTrans"]
ENV DFNTRANS_EXE="/workspace/dfnWorks/bin/DFNTrans"

WORKDIR $dfnworks_PATH/DFN_Mesh_Connectivity_Test
RUN ["make","clean"]
RUN ["make"]
RUN ["cp","ConnectivityTest","../bin/ConnectivityTest"]
ENV CONNECT_TEST_EXE="/workspace/dfnWorks/bin/ConnectivityTest"

WORKDIR $dfnworks_PATH/pydfnworks
RUN python3 setup.py bdist_wheel
#RUN python -m pip install dist/pydfnworks-2.6.1-py3-none-any.whl
# version in dfnWorks/pydfnworks/pydfnworks/release.py
RUN python3 -m pip install dist/pydfnworks-2.7-py3-none-any.whl
WORKDIR $dfnworks_PATH

#############################################################

ENV PETSC_DIR="/usr/local/petsc_v3.18.6/"
# leave PETSC_ARCH empty
ENV PETSC_ARCH=""
ENV PFLOTRAN_EXE="/workspace/pflotran/src/pflotran/pflotran"
ENV LAGRIT_EXE="/workspace/LaGriT/src/lagrit"
ENV FEHM_EXE="/workspace/FEHM/src/xfehm_v3.3.1"

ENV MPIRUN="/usr/local/mpich_4.0.3/bin/mpirun"

# ENTRYPOINT ["/workspace/pflotran/src/pflotran/pflotran"]
# ENTRYPOINT [ "/bin/bash", "-c" ] # this requires arguments passed in quotes
ENTRYPOINT [ ] # resets to default
