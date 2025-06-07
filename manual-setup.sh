#!/bin/bash
# This script is not auto generate

DEPLOY_DIR='/etc/nginx/conf.d/handson-test'
CONF_NAME='websv.conf'

echo "--- Starting Nginx setup ---"
SCRIPT_DIR=$(dirname "$0")
pushd "${SCRIPT_DIR}" >/dev/null
apt update && apt install -y nginx
systemctl stop nginx

echo "--- Creating deployment directory ---"
[ -d ${DEPLOY_DIR} ] && rm -rf ${DEPLOY_DIR}
mkdir -p ${DEPLOY_DIR}



echo "--- Copy files ---"
cp -rf ./src/* ${DEPLOY_DIR}
sed -i "s@PLEASE_REPLACE_DEPLOY_DIR@${DEPLOY_DIR}@g" ${DEPLOY_DIR}/${CONF_NAME}


echo "--- Setting up symbolic links and services ---"
[ -L /etc/nginx/conf.d/${CONF_NAME} ] && unlink /etc/nginx/conf.d/${CONF_NAME}
ln -s ${DEPLOY_DIR}/${CONF_NAME} /etc/nginx/conf.d/${CONF_NAME}
find /etc/nginx/sites-enabled -type l -delete
systemctl enable --now nginx
popd >/dev/null