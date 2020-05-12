#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli.yaml run \
  --rm cli bash ./cli/runCC.sh
