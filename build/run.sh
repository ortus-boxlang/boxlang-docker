#!/bin/bash
set -e

# If a custom user is requested set it before we begin
if [[ $USER ]] && [[ $USER != $(whoami) ]]; then
    # logMessage 'INFO' "Configuration set to non-root user: ${USER}"
    if [[ ! $USER_ID ]]; then
        export USER_ID=1001
    fi

    export HOME=/home/$USER

    if [[ -f /etc/alpine-release ]]; then
        # If the user exists then we skip the directory migrations as the container is in restart
        if ! id -u $USER > /dev/null 2>&1; then
            adduser $USER --uid $USER_ID --home $HOME --disabled-password --ingroup $WORKGROUP
        fi
    else
        # If the user exists then we skip the directory migrations as the container is in restart
        if ! id -u $USER > /dev/null 2>&1; then
            useradd -u $USER_ID $USER
            usermod -a -G $WORKGROUP $USER
            # Ensure our user home directory exists - we need to create it manually for Alpine builds
            mkdir -p $HOME
        fi
    fi

    # Ensure permissions on relevant directories and any files created previously
    chown -R $USER:$WORKGROUP $HOME
    chown -R $USER:$WORKGROUP $APP_DIR
    chown -R $USER:$WORKGROUP $BUILD_DIR
    chown -R $USER:$WORKGROUP $BX_HOME
    chown -R root:$WORKGROUP $BIN_DIR
    chmod g+wrx $BIN_DIR
    # This might change to boxlang home
    mkdir -p ${LIB_DIR}/serverHome
    chown -R $USER:$WORKGROUP ${LIB_DIR}/serverHome

    if [ $BOX_SERVER_APP_SERVERHOMEDIRECTORY ]; then
        chown -R $USER $BOX_SERVER_APP_SERVERHOMEDIRECTORY
    fi

    # Go to the app directory where we will run the server
    cd $APP_DIR

    if [[ -f /etc/alpine-release ]]; then
        su -p -c $BUILD_DIR/run.sh $USER
    else
        su --preserve-environment -c $BUILD_DIR/run.sh $USER
    fi

fi

# Go to the app directory where we will run the server
cd $APP_DIR

# Server Home
export BOXLANG_HOME=${HOME}/.boxlang

# If you have a DEBUG env variable set, we will start the server in debug mode
if [[ $DEBUG == true ]]; then
    export BOXLANG_DEBUG=true
fi

# Run our server
boxlang-miniserver --host ${HOST} --port ${PORT}
