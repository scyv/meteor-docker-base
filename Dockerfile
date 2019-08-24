FROM debian:buster-slim
LABEL maintainer="scyv@posteo.de"

ARG NODE_VERSION=v8.15.1
ARG METEOR_RELEASE=1.8.1
ARG NPM_VERSION=latest
ARG FIBERS_VERSION=3.1.1
ARG ARCHITECTURE=linux-x64

ENV BUILD_DEPS="apt-utils bsdtar gnupg gosu wget curl bzip2 build-essential python python3 python3-distutils git ca-certificates gcc-7" \
    NODE_VERSION=${NODE_VERSION} \
    METEOR_RELEASE=${METEOR_RELEASE} \
    NPM_VERSION=${NPM_VERSION} \
    FIBERS_VERSION=${FIBERS_VERSION} \
    ARCHITECTURE=${ARCHITECTURE}

RUN echo ------------------------------------------------------------------------------------------ && \
    echo Building the image for: && \
    echo "  Meteor: ${METEOR_RELEASE}" && \
    echo "  Node: ${NODE_VERSION}" && \
    echo "  NPM: ${NPM_VERSION}" && \
    echo "  Fibers: ${FIBERS_VERSION}" && \
    echo "  Architecture: ${ARCHITECTURE}" && \
    echo ------------------------------------------------------------------------------------------

# Prepare Build environment
# Meteor installer doesn't work with the default tar binary, so using bsdtar while installing.
# https://github.com/coreos/bugs/issues/1095#issuecomment-350574389
RUN set -o xtrace && \
    mkdir /home/meteor && \
    useradd --user-group --system --home-dir /home/meteor meteor && \
    apt-get update -y && apt-get install -y --no-install-recommends ${BUILD_DEPS} && \
    cp $(which tar) $(which tar)~ && \
    ln -sf $(which bsdtar) $(which tar)

# Download nodejs
# Verify nodejs authenticity
# Install Node
# Install Node dependencies
# Install meteor
RUN wget https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${ARCHITECTURE}.tar.gz && \
    wget https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc && \
    grep ${NODE_VERSION}-${ARCHITECTURE}.tar.gz SHASUMS256.txt.asc | shasum -a 256 -c - && \
    rm -f SHASUMS256.txt.asc && \
    tar xvzf node-${NODE_VERSION}-${ARCHITECTURE}.tar.gz && \
    rm node-${NODE_VERSION}-${ARCHITECTURE}.tar.gz && \
    mv node-${NODE_VERSION}-${ARCHITECTURE} /opt/nodejs && \
    ln -s /opt/nodejs/bin/node /usr/bin/node && \
    ln -s /opt/nodejs/bin/npm /usr/bin/npm && \
    npm install -g npm@${NPM_VERSION} && \
    npm install -g node-gyp && \
    npm install -g fibers@${FIBERS_VERSION} && \
    chown meteor:meteor --recursive /home/meteor

# Install Meteor forcing its progress
RUN curl "https://install.meteor.com" -o /home/meteor/install_meteor.sh && \
    cd /home/meteor/ && \
    sed -i 's/VERBOSITY="--silent"/VERBOSITY="--progress-bar"/' ./install_meteor.sh && \
    echo "Starting meteor ${METEOR_RELEASE} installation...   \n" && \
    chown meteor:meteor /home/meteor/install_meteor.sh && \
    gosu meteor:meteor sh /home/meteor/install_meteor.sh && \
    chown meteor:meteor --recursive /home/meteor
