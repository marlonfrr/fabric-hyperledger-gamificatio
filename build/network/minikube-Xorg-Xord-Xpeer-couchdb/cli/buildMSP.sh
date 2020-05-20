#!/bin/bash

cryptogen generate --config=./fabric/crypto-config-org1.yaml \
  --output="./build/organizations"

cryptogen generate --config=./fabric/crypto-config-org2.yaml \
  --output="./build/organizations"

cryptogen generate --config=./fabric/crypto-config-orderer.yaml \
  --output="./build/organizations"
