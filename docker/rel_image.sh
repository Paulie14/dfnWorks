#!/bin/bash

# repo=https://github.com/lanl/dfnWorks.git
repo=https://github.com/Paulie14/dfnWorks.git
commit=master

docker build \
--build-arg source_repository=$repo \
--build-arg commit=$commit \
-t flow123d/dfnworks-gnu-rel \
-f ./docker/rel-image/Dockerfile .

