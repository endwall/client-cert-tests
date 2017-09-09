#! /bin/bash

set -e

OUTPUT_DIR=${1:-$PWD}

if [ -e $OUTPUT_DIR/server/massl.server.key.pem ] && [ -e $OUTPUT_DIR/server/massl.server.crt.pem ]; then
    echo "certs exists already!"
else
    echo "Generate certs"
    openssl genrsa \
      -out tmp_$$.server.key.pem \
      2048

    # Generate CSR
    openssl req \
      -new \
      -sha256 \
      -key tmp_$$.server.key.pem \
      -out tmp_$$.server.csr.pem \
      -subj "/C=AU/ST=Victoria/L=Melbourne/O=endwall Systems/CN=endwall server cert"

    # Sign the cert
    openssl x509 \
      -req -in tmp_$$.server.csr.pem \
      -CA $OUTPUT_DIR/intermediate/massl.intermediate.crt.pem \
      -CAkey $OUTPUT_DIR/intermediate/massl.intermediate.key.pem \
      -CAcreateserial \
      -extensions server_cert \
      -sha256 \
      -out tmp_$$.server.crt.pem \
      -days 5000    

    mv tmp_$$.server.key.pem $OUTPUT_DIR/server/massl.server.key.pem
    mv tmp_$$.server.csr.pem $OUTPUT_DIR/server/massl.server.csr.pem    
    mv tmp_$$.server.crt.pem $OUTPUT_DIR/server/massl.server.crt.pem
fi
