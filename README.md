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
| METEOR_RELEASE |  The release version of Meteor | 1.8.2 |
| NODE_VERSION |    The release version of Node   |   v8.16.2 |
| NPM_VERSION | The release version of NPM |    6.13.0 |
| FIBERS_VERSION | Version of the fibers npm package | 3.1.1 |
| ARCHITECTURE | target architecture (used to fetch the correct node package) | linux-x64 |

You can override the defaults e.g. with:

```
docker build -t meteor-base:my-special-arg --build-arg METEOR_RELEASE=1.8.1  .
```

## Usage

* To build a complete meteor app in a docker container, use a Dockerfile like https://github.com/scyv/scrum-poker/blob/master/Dockerfile
* Recommended is a docker-compose file like https://github.com/scyv/scrum-poker/blob/master/docker-compose.yml to start a complete environment (with mongodb)
