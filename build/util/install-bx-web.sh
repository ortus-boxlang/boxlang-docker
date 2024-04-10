#!/bin/bash

# Make sure errors (like curl failing, or unzip failing, or anything failing) fails the build
set -ex

if [ -z "$BX_VERSION" ]; then
  echo "BX Version not supplied via variable BX_VERSION"
  exit 1
fi

# Installs the latest CommandBox Binary
mkdir -p /tmp
curl -k  -o /tmp/bx-web.jar -location "https://ortus-temp.s3.amazonaws.com/jericho/libs/boxlang-${BX_VERSION}-web.jar"
mv /tmp/bx-web.jar ${BIN_DIR}/bx-web.jar && chmod 777 ${BIN_DIR}/bx-web.jar
echo "#!/bin/bash" ${BIN_DIR}/bx.sh
echo "java -jar ${BIN_DIR}/bx-web.jar --host 0.0.0.0" >> ${BIN_DIR}/bx.sh && chmod 755 ${BIN_DIR}/bx.sh

# unzip /tmp/box.zip -d ${BIN_DIR} && chmod 755 ${BIN_DIR}/box && rm -f /tmp/box.zip
echo "bx_home=${BX_HOME}" > ${BIN_DIR}/bx.properties

# echo "$(bx version) successfully installed"

# box uninstall --system commandbox-update-check

# Swap out binary with thin client now that everything is expanded
# curl https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/${BX_VERSION}/box-thin -o ${BIN_DIR}/box

# Set container in to single server mode
# box config set server.singleServerMode=true

# Set our log pattern to be ISO with timezone info, as containers might be running in different zones
# box config set server.defaults.runwar.console.appenderLayoutOptions.pattern="[%p] %d{yyyy-MM-dd\'T\'HH:mm:ssXXX} %c - %m%n"

# Install GELF jar for Java.util JSON logging https://logging.paluch.biz/examples/jul-json.html
# mkdir -p $JAVA_HOME/classes
# curl http://search.maven.org/remotecontent?filepath=biz/paluch/logging/logstash-gelf/1.15.0/logstash-gelf-1.15.0.jar -o $JAVA_HOME/classes/logstash-gelf-1.15.0.jar
# curl http://search.maven.org/remotecontent?filepath=biz/paluch/logging/logstash-gelf/1.15.0/logstash-gelf-1.15.0.jar.md5 -o $JAVA_HOME/classes/logstash-gelf-1.15.0.jar.md5
# md5sum  $JAVA_HOME/classes/logstash-gelf-1.15.0.jar > $JAVA_HOME/classes/logstash-gelf-1.15.0.jar.md5

# $BUILD_DIR/util/optimize.sh
