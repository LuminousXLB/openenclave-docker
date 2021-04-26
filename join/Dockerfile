FROM ncl-sgx/openenclave:dev-1.8

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=ubuntu
ARG GNAME=ubuntu
ARG UID=1000
ARG GID=1000

USER ${UID}

WORKDIR /home/${UNAME}

CMD sudo service ssh start && autossh -N -R 42522:localhost:22 ubuntu@aws.taraxacum.ink
