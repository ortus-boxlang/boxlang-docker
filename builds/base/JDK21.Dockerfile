FROM eclipse-temurin:21-jdk-jammy

ARG IMAGE_VERSION
ARG BOXLANG_VERSION

LABEL version ${IMAGE_VERSION}
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL maintainer "Luis Majano <lmajano@ortussolutions.com>"
LABEL repository "https://github.com/ortus-boxlang/docker-boxlang"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Since alpine runs as a single user, we need to create a "root" directory
# This is where the BoxLang HOME will be stored /root/.boxlang
ENV HOME /root

# Alpine workgroup is root group
ENV WORKGROUP root

### Directory Mappings ###

# BIN_DIR = Where the box binary goes
ENV BIN_DIR /usr/local/bin
# LIB_DIR = Where the build files go
ENV LIB_DIR /usr/local/lib
WORKDIR $BIN_DIR

# APP_DIR = the directory where the application runs
ENV APP_DIR /app
WORKDIR $APP_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR $LIB_DIR/build
WORKDIR $BUILD_DIR

# Copy file system and test system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/

# Ensure all workgroup users have permission on the build scripts
RUN chown -R nobody:${WORKGROUP} $BUILD_DIR
RUN chmod -R +x $BUILD_DIR

# bx Installation
RUN $BUILD_DIR/util/debian/install-dependencies.sh
RUN $BUILD_DIR/util/install-bx.sh

# Test it
RUN boxlang -c 2+2

WORKDIR $APP_DIR

CMD [ "boxlang", "message='BoxLang CLI is alive';println(message)" ]
