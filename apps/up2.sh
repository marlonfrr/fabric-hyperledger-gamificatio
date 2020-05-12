#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose-org2-api1.yaml up
