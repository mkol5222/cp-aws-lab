#!/bin/bash

set -euo pipefail

SECRETS_FOLDER="../secrets"
# folder should be created if it does not exist
if [ ! -d $SECRETS_FOLDER ]; then
  mkdir -p $SECRETS_FOLDER
fi

SIC_KEY_FILE="$SECRETS_FOLDER/gateway_sic_key.txt"
# generate sic key with openssl rand -base64 12, if file does not exist
if [ ! -f $SIC_KEY_FILE ]; then
  openssl rand -base64 12 > $SIC_KEY_FILE
fi
export TF_VAR_gateway_sic_key=$(cat $SIC_KEY_FILE)

# admin password for the gateways
ADMIN_PASSWORD_FILE="$SECRETS_FOLDER/gateway_admin_password.txt"
# generate admin password with openssl rand -base64 12, if file does not exist
if [ ! -f $ADMIN_PASSWORD_FILE ]; then
  openssl rand -base64 12 > $ADMIN_PASSWORD_FILE
  openssl passwd -6 -stdin < $ADMIN_PASSWORD_FILE > $ADMIN_PASSWORD_FILE.hashed
fi
export TF_VAR_gateway_admin_password=$(cat $ADMIN_PASSWORD_FILE.hashed)
