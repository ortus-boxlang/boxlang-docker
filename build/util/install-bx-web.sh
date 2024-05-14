#!/bin/bash

# Make sure errors (like curl failing, or unzip failing, or anything failing) fails the build
set -ex

if [ -z "$BOXLANG_VERSION" ]; then
  echo "BX Version not supplied via variable BOXLANG_VERSION"
  exit 1
fi

# Installs the latest CommandBox Binary
mkdir -p /tmp
curl -k  -o /tmp/bx-web.jar -location "https://downloads.ortussolutions.com/ortussolutions/boxlang-runtimes/boxlang-miniserver/${BOXLANG_VERSION}/boxlang-miniserver-${BOXLANG_VERSION}-all.jar"
mv /tmp/bx-web.jar ${BIN_DIR}/bx-web.jar && chmod 777 ${BIN_DIR}/bx-web.jar
echo "#!/bin/bash" ${BIN_DIR}/bx.sh
echo "java -jar ${BIN_DIR}/bx-web.jar --host 0.0.0.0" >> ${BIN_DIR}/bx.sh && chmod 755 ${BIN_DIR}/bx.sh

# unzip /tmp/box.zip -d ${BIN_DIR} && chmod 755 ${BIN_DIR}/box && rm -f /tmp/box.zip
echo "bx_home=${BX_HOME}" > ${BIN_DIR}/bx.properties
