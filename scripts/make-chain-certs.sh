#! /bin/bash

CERT_DIR=${1:-../certs}

mkdir -p $CERT_DIR/chain

cat $CERT_DIR/intermediate/massl.intermediate.crt.pem \
     $CERT_DIR/ca/massl.root-ca.crt.pem > $CERT_DIR/chain/massl.chain.crt.pem