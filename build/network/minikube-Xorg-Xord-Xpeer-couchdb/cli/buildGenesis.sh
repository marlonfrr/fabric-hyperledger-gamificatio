#!/bin/bash

echo "Generate CCP files for Org1 and Org2"
./cli/ccp-generate.sh

export FABRIC_CFG_PATH=${PWD}/fabric
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./build/system-genesis-block/genesis.block
configtxgen -inspectBlock ./build/system-genesis-block/genesis.block > ./build/system-genesis-block/genesis.json
