#!/bin/bash -xe

CHAINCODE_NAME="chaincode"
VERSION="1"
unset FABRIC_CFG_PATH

CC_RUNTIME_LANGUAGE=node
CC_SRC_PATH="../smartcontracts/contract/"

. ./cli/envVar.sh 1 0
peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} \
  --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${VERSION}
mv ./${CHAINCODE_NAME}.tar.gz ./build/

. cli/envVar.sh 1 0
peer lifecycle chaincode install ./build/$CHAINCODE_NAME.tar.gz

. cli/envVar.sh 1 1
peer lifecycle chaincode install ./build/$CHAINCODE_NAME.tar.gz

. cli/envVar.sh 2 0
peer lifecycle chaincode install ./build/$CHAINCODE_NAME.tar.gz

. cli/envVar.sh 2 1
peer lifecycle chaincode install ./build/$CHAINCODE_NAME.tar.gz


. cli/envVar.sh 1 0
PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | \
sed -n "/${CHAINCODE_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}")

. cli/envVar.sh 1 0
peer lifecycle chaincode approveformyorg -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS --tls $CORE_PEER_TLS_ENABLED \
	--cafile $ORDERER1_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME \
	--version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
	--sequence ${VERSION}

. cli/envVar.sh 2 0
peer lifecycle chaincode approveformyorg -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS --tls $CORE_PEER_TLS_ENABLED \
	--cafile $ORDERER1_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME \
	--version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
	--sequence ${VERSION}


. cli/envVar.sh 1 0
peer lifecycle chaincode checkcommitreadiness \
  --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version ${VERSION} \
	--sequence ${VERSION} --output json --init-required

. cli/envVar.sh 2 0
peer lifecycle chaincode checkcommitreadiness \
  --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version ${VERSION} \
	--sequence ${VERSION} --output json --init-required


PEER_CONN_PARMS=""
. cli/envVar.sh 1 0
PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE"
. cli/envVar.sh 1 1
PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE"
. cli/envVar.sh 2 0
PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE"
. cli/envVar.sh 2 1
PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE"
. cli/envVar.sh 1 0
peer lifecycle chaincode commit -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS --tls $CORE_PEER_TLS_ENABLED \
  --cafile $ORDERER1_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME \
  $PEER_CONN_PARMS --version ${VERSION} --sequence ${VERSION} --init-required

. cli/envVar.sh 1 0
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME

. cli/envVar.sh 1 1
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME

. cli/envVar.sh 2 0
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME

. cli/envVar.sh 2 1
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME


. cli/envVar.sh 1 0
peer chaincode invoke -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS --tls $CORE_PEER_TLS_ENABLED \
  --cafile $ORDERER1_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME $PEER_CONN_PARMS \
  --isInit -c '{"function":"init","Args":["a","10","b","20"]}'
