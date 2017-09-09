#! /bin/bash

set -e

OUTPUT_DIR=${1:-$PWD}

# Create your very own Root Certificate Authority
if [ -e $OUTPUT_DIR/massl.root-ca.key.pem ] && [ -e $OUTPUT_DIR/massl.root-ca.crt.pem ]; then
    echo "root ca exists already!"
else
    echo "Generate root ca"
    openssl genrsa \
      -out $OUTPUT_DIR/tmp_$$.root-ca.key.pem \
      2048

    # Self-sign the Root Certificate Authority
    openssl req \
      -x509 \
      -new \
      -nodes \
      -sha256 \
      -key $OUTPUT_DIR/tmp_$$.root-ca.key.pem \
      -days 1024 \
      -out $OUTPUT_DIR/tmp_$$.root-ca.crt.pem \
      -subj "/C=AU/ST=Victoria/L=Melbourne/O=endwall Systems/CN=endwall.io"


    mv $OUTPUT_DIR/tmp_$$.root-ca.key.pem $OUTPUT_DIR/massl.root-ca.key.pem
    mv $OUTPUT_DIR/tmp_$$.root-ca.crt.pem $OUTPUT_DIR/massl.root-ca.crt.pem
fi
