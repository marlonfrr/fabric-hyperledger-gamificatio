#!/bin/bash

rm -rf ./build
mkdir -p ./build

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli.yaml run \
  --rm cli bash ./cli/buildMSP.sh
