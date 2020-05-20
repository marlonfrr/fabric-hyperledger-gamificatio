#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose-org1-io.yaml \
  run --rm api-server bash
