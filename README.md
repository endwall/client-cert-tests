MASSL Test

# Purpose
In the environment that outbound networking needs client certificate to communicate with external server. There is forward proxy deployed already for outbound networking. As it is a secure environment (Assumption), we could deploy the client certificate into the forward proxy so that the forward proxy handle MASSL handshake on behalf of the actual client. As a result of that within the environment, HTTP only is needed. 

Alternative is that the client loads client certificate.

# Test Senario

Nginx <=> Backend (Simple Client) <=> Forward Proxy (Squid) <=> Service (Simple Server)

# Code Structure
## certs
All the CA, client certificates, server certificates and intermediate CAs.

## scripts
All the scripts for certificates generation

## simple-express-client
Node express client

## simple-express-server
Node express server

## squid
use jamesyale/squid-sslbump which has sslbump enabled. otherwise could build by ourselves.

## docker-compose
- docker-compose-squid.yml
  simulate the environment above

## Test Command
curl http://$(docker-compose ip default):8000/
curl http://$(docker-compose ip default):8000/users

curl -k --cert <cert> --key <key> --cacert <ca> https://$(docker-compose ip default):8001/

curl -k --cert <cert> --key <key> --cacert <ca> https://$(docker-compose ip default):8001/users


# TODO
Due to the time, there are a few things left.
- Current config/cert does not support intermediate CA
  This has cause me lots of trouble, hence lots of time.
- Squid config for client certificate
  Hasn't pass the test, the squid config still need some change, but should almost there.