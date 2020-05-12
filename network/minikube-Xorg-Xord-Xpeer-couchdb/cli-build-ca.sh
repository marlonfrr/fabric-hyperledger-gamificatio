#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli-build-ca.yaml run --rm cli bash
