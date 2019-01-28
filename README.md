# meteor-docker-base
Dockerfile for creating a base image for building and running meteor apps in docker containers

## Build docker image

Build the docker image with:

```
docker build -t meteor-base:latest .
```

## Build Arguments

There are some build arguments that can be used to give the build some input:

| Argument | Description | default |
|---|---|---|
| METEOR_RELEASE |  The release version of Meteor | 1.8.0.2 |
| NODE_VERSION |    The release version of Node   |   v8.15.0 |
| NPM_VERSION | The release version of NPM |    latest |
| FIBERS_VERSION | Version of the fibers npm package | 2.0.0 |
| ARCHITECTURE | target architecture (used to fetch the correct node package) | linux-x64 |

You can override the defaults e.g. with:

```
docker build -t meteor-base:my-special-arg --build-arg METEOR_RELEASE=1.8.0.1  .
```
