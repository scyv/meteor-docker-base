FROM ubuntu:latest
LABEL maintainer="scyv@posteo.de"


ENV BUILD_DEPS="apt-utils curl build-essential git ca-certificates"

RUN set -o xtrace && \
    mkdir /home/meteor && \
    useradd --user-group --system --home-dir /home/meteor meteor && \
    chown meteor:meteor --recursive /home/meteor && \
    apt-get update -y && apt-get install -y --no-install-recommends ${BUILD_DEPS} 

USER meteor

RUN curl https://install.meteor.com/ | sh
    
ENV PATH=~/.meteor:$PATH

