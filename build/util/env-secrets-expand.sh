#!/bin/bash

################################################################################
# Docker Secrets Expansion Script
#
# This script automatically expands environment variables from Docker secrets
# at container startup. It supports two expansion patterns:
#
# 1. SECRET Placeholder Pattern:
#    ENV_VAR=<<SECRET:my-secret-name>>
#    Reads from /run/secrets/my-secret-name and sets ENV_VAR to the content
#
# 2. _FILE Suffix Pattern:
#    ENV_VAR_FILE=/path/to/secret/file
#    Reads the file and sets ENV_VAR (without _FILE suffix) to the content
#    Example: DATABASE_PASSWORD_FILE=/run/secrets/db_password
#             → Sets DATABASE_PASSWORD to the file contents
#
# Exclusions:
# Certain BoxLang/MiniServer configuration variables ending in _FILE are
# excluded from expansion (e.g., REWRITE_FILE, REWRITES_FILE) as they
# are legitimate config values, not secret file paths.
#
# Usage:
# This script is automatically sourced by /usr/local/lib/build/run.sh
# at container startup. No manual invocation needed.
#
# Debug Mode:
# Set ENV_SECRETS_DEBUG=true to enable debug logging of secret expansion
################################################################################

# credit: https://medium.com/@basi/docker-environment-variables-expanded-from-secrets-8fa70617b3bc

: ${ENV_SECRETS_DIR:=/run/secrets}

env_secret_debug()
{
    if [ ! -z "$ENV_SECRETS_DEBUG" ]; then
        logMessage "DEBUG" "$1"
    fi
}

# usage: env_secret_expand VAR
#    ie: env_secret_expand 'XYZ_DB_PASSWORD'
# (will check for "$XYZ_DB_PASSWORD" variable value for a placeholder that defines the
#  name of the docker secret to use instead of the original value. For example:
# XYZ_DB_PASSWORD=<<SECRET:my-db.secret>>
env_secret_expand() {
    local var="$1"
    eval local val=\$$var
    local secret_name=$(expr match "$val" "<<SECRET:\([^}]\+\)>>$")

    # Exclude known BoxLang/MiniServer config variables from secret expansion
    local excluded_vars="REWRITE_FILE REWRITES_FILE"

    if [[ $secret_name ]]; then
        local secret="${ENV_SECRETS_DIR}/${secret_name}"
    elif [[ ${var:(-5)} = '_FILE' ]] && [[ ! " $excluded_vars " =~ " $var " ]]; then
        local suffix=${var:(-5)}
        local secret=$val
    fi

    if [[ $secret ]]; then
        env_secret_debug "Secret file for $var: $secret"
        if [ -f "$secret" ]; then
            val=$(cat "${secret}")
            if [ $suffix ]; then
                echo "Expanding from _FILE suffix"
                var=$(echo $var | rev | cut -d '_' -f 2- | rev);
            fi
            export "$var"="$val"
            env_secret_debug "Expanded variable: $var=$val"
        else
            export "$var"=""
            env_secret_debug "Secret file does not exist! $secret"
        fi
    fi
}

env_secrets_expand() {
    for env_var in $(printenv | cut -f1 -d"=")
    do
        env_secret_expand $env_var
    done

    if [ ! -z "$ENV_SECRETS_DEBUG" ]; then
        logMessage "DEBUG" 'Expanded environment variables'
        printenv
    fi
}

env_secrets_expand
