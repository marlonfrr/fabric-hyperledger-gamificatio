#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose-org2-io-endpoint.yaml \
  run --rm api-server bash
