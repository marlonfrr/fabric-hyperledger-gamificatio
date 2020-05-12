#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose-org1-api1.yaml down
