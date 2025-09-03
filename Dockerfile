FROM node:lts-slim
LABEL maintainer="scyv@posteo.de"

ENV BUILD_DEPS="apt-utils curl build-essential git ca-certificates"

RUN apt-get update -y && apt-get install -y --no-install-recommends ${BUILD_DEPS} 

USER node

RUN curl https://install.meteor.com/ | sh
    
ENV PATH=/home/node/.meteor:$PATH

