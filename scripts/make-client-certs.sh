#! /bin/bash

set -e

OUTPUT_DIR=${1:-$PWD}

if [ -e $OUTPUT_DIR/client/massl.client.key.pem ] && [ -e $OUTPUT_DIR/client/massl.client.crt.pem ]; then
    echo "certs exists already!"
else
    echo "Generate certs"
    mkdir -p ${OUTPUT_DIR}/client
    openssl genrsa \
      -out tmp_$$.client.key.pem \
      2048

    # Generate CSR
    openssl req \
      -new \
      -sha256 \
      -key tmp_$$.client.key.pem \
      -out tmp_$$.client.csr.pem \
      -subj "/C=AU/ST=Victoria/L=Melbourne/O=endwall Systems/CN=endwall client cert"

    # Sign the cert
    openssl x509 \
      -req -in tmp_$$.client.csr.pem \
      -CA $OUTPUT_DIR/intermediate/massl.intermediate.crt.pem \
      -CAkey $OUTPUT_DIR/intermediate/massl.intermediate.key.pem \
      -CAcreateserial \
      -extensions usr_cert \
      -sha256 \
      -out tmp_$$.client.crt.pem \
      -days 5000    

    mv tmp_$$.client.key.pem $OUTPUT_DIR/client/massl.client.key.pem
    mv tmp_$$.client.csr.pem $OUTPUT_DIR/client/massl.client.csr.pem    
    mv tmp_$$.client.crt.pem $OUTPUT_DIR/client/massl.client.crt.pem
fi
