# !/bin/bash

set -e

# this script generates a SSL certificates for an massl endpoints
#
# cmd: make-certs.sh endpoint
# sample:
#      make-certs.sh backend
# input:
# output:
#  encrypted files:
#   <endpoint>.key.pem, 
#   <endpoint>.crt.pem, 
#   <endpoint>-root-ca.key.pem, 
#   <endpoint>-root-ca.crt.pem, 

PROJECT_NAME=$1
DEPLOY_ENV=$2
FQDN=elk.${DEPLOY_ENV}.${PROJECT_NAME}.endwall.io

trap cleanup EXIT
function cleanup {
    rm -f tmp_$$.*
}

function usage {
    echo >&2 ${1-"Usage: make-certs.sh <endpoint>"}
    exit 2
}


if [ $# -lt 1 ] ;then
    usage
fi

if [ ${#FQDN} -gt 64 ]; then
    echo "Please use a short name for service and project name as CN can't exceed 64 (${#FQDN} already)"
    exit 3
fi

# Create your very own Root Certificate Authority
openssl genrsa \
  -out tmp_$$.root-ca.key.pem \
  2048

# Self-sign your Root Certificate Authority
openssl req \
  -x509 \
  -new \
  -nodes \
  -key tmp_$$.root-ca.key.pem \
  -days 1024 \
  -out tmp_$$.root-ca.crt.pem \
  -subj "/C=AU/ST=Victoria/L=Melbourne/O=endwall Systems/CN=endwall.io"

openssl genrsa \
  -out tmp_$$.key.pem \
  2048

openssl req -new \
  -key tmp_$$.key.pem \
  -out tmp_$$.csr.pem \
  -subj "/C=AU/ST=Victoria/L=Melbourne/O=endwall Systems/CN=${FQDN}"

openssl x509 \
  -req -in tmp_$$.csr.pem \
  -CA tmp_$$.root-ca.crt.pem \
  -CAkey tmp_$$.root-ca.key.pem \
  -CAcreateserial \
  -out tmp_$$.crt.pem \
  -days 5000

kms -e tmp_$$.root-ca.key.pem -o elk-root-ca.key.pem.kms
kms -e tmp_$$.root-ca.crt.pem -o elk-root-ca.crt.pem.kms
kms -e tmp_$$.key.pem -o elk.key.pem.kms
kms -e tmp_$$.crt.pem -o elk.crt.pem.kms