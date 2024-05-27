FROM eclipse-temurin:21-jdk-jammy

ARG IMAGE_VERSION
ARG BOXLANG_VERSION

LABEL version ${IMAGE_VERSION}
LABEL maintainer "Jon Clausen <jclausen@ortussolutions.com>"
LABEL repository "https://github.com/ortus-boxlang/docker-boxlang"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Since alpine runs as a single user, we need to create a "root" direcotry
ENV HOME /root

# Alpine workgroup is root group
ENV WORKGROUP root

### Directory Mappings ###

# BIN_DIR = Where the box binary goes
ENV BIN_DIR /usr/bin
# LIB_DIR = Where the build files go
ENV LIB_DIR /usr/lib
WORKDIR $BIN_DIR

# APP_DIR = the directory where the application runs
ENV APP_DIR /app
WORKDIR $APP_DIR

# BUILD_DIR = WHERE runtime scripts go
ENV BUILD_DIR $LIB_DIR/build
WORKDIR $BUILD_DIR

# COMMANDBOX_HOME = Where CommmandBox Lives
# ENV COMMANDBOX_HOME=$LIB_DIR/CommandBox

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/

# Ensure all workgroup users have permission on the build scripts
RUN chown -R nobody:${WORKGROUP} $BUILD_DIR
RUN chmod -R +x $BUILD_DIR

RUN $BUILD_DIR/util/debian/install-dependencies.sh

RUN $BUILD_DIR/util/install-bx.sh

RUN java -jar ${BIN_DIR}/bx-all.jar -c 2+2

WORKDIR $APP_DIR

CMD [ "bx.sh", "message='BoxLang CLI is alive';println(message)" ]
