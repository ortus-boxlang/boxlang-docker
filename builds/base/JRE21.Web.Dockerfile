FROM eclipse-temurin:21-jre-noble

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

# Copy file system
COPY ./test/ ${APP_DIR}/
COPY ./build/ ${BUILD_DIR}/

# Ensure all workgroup users have permission on the build scripts
RUN chown -R nobody:${WORKGROUP} $BUILD_DIR
RUN chmod -R +x $BUILD_DIR

# bx Installation
RUN $BUILD_DIR/util/debian/install-dependencies.sh
RUN $BUILD_DIR/util/install-bx.sh

# ENV
ENV DEBUG false
ENV HOST 0.0.0.0
ENV PORT 8080
ENV SSL_PORT 8443
# Add an env for max memory
ENV MAX_MEMORY "512m"
# Add an env for min memory
ENV MIN_MEMORY "512m"
# Rewrites enabled
ENV REWRITES true
# Rewrite File
ENV REWRITE_FILE "index.bxm"
# JAVA Options
ENV JAVA_OPTS "-Xmx${MAX_MEMORY} -Xms${MIN_MEMORY} -Djava.awt.headless=true"
# ENV CONFIG_PATH /path/to/boxlang.json
# All the JVM options to send to the mini server

# Healthcheck environment variables
ENV HEALTHCHECK_URI "http://127.0.0.1:${PORT}/"

# Our healthcheck interval doesn't allow dynamic intervals - Default is 20s intervals with 15 retries
HEALTHCHECK --interval=20s --timeout=30s --retries=15 CMD curl --fail ${HEALTHCHECK_URI} || exit 1

EXPOSE ${PORT} ${SSL_PORT}

WORKDIR $APP_DIR

CMD $BUILD_DIR/run.sh
