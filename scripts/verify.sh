#! /bin/bash
set -e
openssl verify -CAfile ../certs/ca/massl.root-ca.crt.pem \
    ../certs/intermediate/massl.intermediate.crt.pem

openssl verify -CAfile ../certs/chain/massl.chain.crt.pem \
    ../certs/server/massl.server.crt.pem

openssl verify -CAfile ../certs/chain/massl.chain.crt.pem \
    ../certs/client/massl.client.crt.pem


