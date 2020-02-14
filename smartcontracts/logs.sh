#!/bin/bash

# docker logs -f orderer.example.com
# docker logs -f peer0.org1.example.com

# docker ps |  awk '($2 ~ dev-peer0.org2.example.com-fabcar_1*) {print $2}'
CONTAINER_ID=$(docker ps |  awk '($2 ~ /dev-peer0\.org2\.example\.com-fabcar_1*/) {print $1}')
docker logs -f $CONTAINER_ID
