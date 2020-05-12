#!/bin/bash

# docker logs -f orderer
# docker logs -f peer0

# docker ps |  awk '($2 ~ dev-peer0.org2.example.com-fabcar_1*) {print $2}'
CONTAINER_ID=$(docker ps |  awk '($2 ~ /dev-peer0\.com-fabcar_1*/) {print $1}')
docker logs -f $CONTAINER_ID
