#!/bin/bash +x

. ./cli/envVar.sh 1 0

export FABRIC_CFG_PATH=${PWD}/fabric

mkdir -p ./build/channel-artifacts

configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./build/channel-artifacts/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
configtxgen -inspectChannelCreateTx ./build/channel-artifacts/mychannel.tx > ./build/channel-artifacts/mychannel.json

orgmsp=Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate \
  ./build/channel-artifacts/${orgmsp}anchors.tx -channelID $CHANNEL_NAME \
	-asOrg ${orgmsp}
configtxgen -inspectChannelCreateTx ./build/channel-artifacts/${orgmsp}anchors.tx > ./build/channel-artifacts/${orgmsp}anchors.tx.json

orgmsp=Org2MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate \
  ./build/channel-artifacts/${orgmsp}anchors.tx -channelID $CHANNEL_NAME \
	-asOrg ${orgmsp}
configtxgen -inspectChannelCreateTx ./build/channel-artifacts/${orgmsp}anchors.tx > ./build/channel-artifacts/${orgmsp}anchors.tx.json


unset FABRIC_CFG_PATH

. ./cli/envVar.sh 1 0
peer channel create -o $ORDERER1_ADDRESS_PORT -c $CHANNEL_NAME \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS \
	-f ./build/channel-artifacts/${CHANNEL_NAME}.tx \
	--outputBlock ./build/channel-artifacts/${CHANNEL_NAME}.block \
	--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER1_CA

configtxlator proto_decode --input ./build/channel-artifacts/${CHANNEL_NAME}.block \
	--type common.Block > ./build/channel-artifacts/${CHANNEL_NAME}.block.json


. cli/envVar.sh 1 0
peer channel join -b ./build/channel-artifacts/$CHANNEL_NAME.block

. cli/envVar.sh 1 1
peer channel join -b ./build/channel-artifacts/$CHANNEL_NAME.block

. cli/envVar.sh 2 0
peer channel join -b ./build/channel-artifacts/$CHANNEL_NAME.block

. cli/envVar.sh 2 1
peer channel join -b ./build/channel-artifacts/$CHANNEL_NAME.block


. cli/envVar.sh 1 0
peer channel update -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS -c $CHANNEL_NAME \
	-f ./build/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx \
	--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER1_CA

. cli/envVar.sh 2 0
peer channel update -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS -c $CHANNEL_NAME \
	-f ./build/channel-artifacts/${CORE_PEER_LOCALMSPID}anchors.tx \
	--tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER1_CA



# Get last config Block, &{NOT_FOUND}?
# peer channel fetch config ./build/channel-artifacts/config_block.pb \
#   -o $ORDERER1_ADDRESS_PORT \
#   --ordererTLSHostnameOverride $ORDERER1_ADDRESS \
#   --tls --cafile $ORDERER1_CA
#
# configtxlator proto_decode --input ./build/channel-artifacts/config_block.pb --type common.Block > ./build/channel-artifacts/config_block.json
