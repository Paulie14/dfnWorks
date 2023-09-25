#!/bin/bash

set -x


# grab user's id
gid=$(id -g)
uid=$(id -u)
# uname=flow
# -euid=$uid -egid=$gid -ewho=$uname

docker_container="flow123d/dfnworks-gnu-rel"
docker_contname="dfnworks-gnu-rel"
docker_user="--user=$uid:$gid --volume=/etc/group:/etc/group:ro --volume=/etc/passwd:/etc/passwd:ro --volume=/etc/shadow:/etc/shadow:ro"
# docker_user=""
docker_args="-t --rm ${docker_user} --name ${docker_contname} -w /$(pwd) -v /$(pwd):/$(pwd)"

# interactive
docker run -it --rm --name ${docker_contname} ${docker_user} \
  -w /$(pwd) -v /$(pwd):/$(pwd) --entrypoint "/bin/bash" ${docker_container}
