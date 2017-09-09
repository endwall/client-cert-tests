#! /bin/bash

set -e

OUTPUT_DIR=${1:-$PWD}

if [ -e $OUTPUT_DIR/intermediate/massl.intermediate.key.pem ] && [ -e $OUTPUT_DIR/intermediate/massl.intermediate.crt.pem ]; then
    echo "certs exists already!"
else
    echo "Generate certs"
    openssl genrsa \
      -out tmp_$$.intermediate.key.pem \
      2048

    # Generate CSR
    openssl req \
      -new \
      -sha256 \
      -key tmp_$$.intermediate.key.pem \
      -out tmp_$$.intermediate.csr.pem \
      -subj "/C=AU/ST=Victoria/L=Melbourne/O=endwall Systems/CN=endwall Intermediated CA"

    # Sign the cert
    openssl x509 \
      -req -in tmp_$$.intermediate.csr.pem \
      -CA $OUTPUT_DIR/ca/massl.root-ca.crt.pem \
      -CAkey $OUTPUT_DIR/ca/massl.root-ca.key.pem \
      -sha256 \
      -CAcreateserial \
      -out tmp_$$.intermediate.crt.pem \
      -days 5000    

    mv tmp_$$.intermediate.key.pem $OUTPUT_DIR/intermediate/massl.intermediate.key.pem
    mv tmp_$$.intermediate.csr.pem $OUTPUT_DIR/intermediate/massl.intermediate.csr.pem    
    mv tmp_$$.intermediate.crt.pem $OUTPUT_DIR/intermediate/massl.intermediate.crt.pem
fi
