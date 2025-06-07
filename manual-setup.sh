#!/bin/bash
# This script is not auto generate

DEPLOY_DIR='/etc/nginx/conf.d/handson-test-html'
CONF_NAME='handson-test.conf'

echo "--- Starting Nginx setup ---"
apt update && apt install -y nginx
systemctl stop nginx

echo "--- Creating deployment directory ---"
[ -d ${DEPLOY_DIR} ] && rm -rf ${DEPLOY_DIR}
mkdir -p ${DEPLOY_DIR}



echo "--- Copy files ---"
cp -rf ./src/* ${DEPLOY_DIR}



echo "--- Setting up symbolic links and services ---"
ln -s ${DEPLOY_DIR}/${CONF_NAME} /etc/nginx/conf.d/${CONF_NAME}
unlink /etc/nginx/sites-enabled/default
systemctl enable --now nginx
