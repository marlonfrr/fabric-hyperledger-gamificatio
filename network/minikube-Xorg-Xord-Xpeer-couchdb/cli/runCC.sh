#!/bin/bash -x

CHAINCODE_NAME="chaincode"

. ./cli/envVar.sh 1 0

peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["query", "a"]}'

PEER_CONN_PARMS=""
. cli/envVar.sh 1 0
PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $PEER0_ORG1_CA"
. cli/envVar.sh 2 0
PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS --tlsRootCertFiles $PEER0_ORG2_CA"

. ./cli/envVar.sh 1 0
peer chaincode invoke -o $ORDERER1_ADDRESS_PORT \
  --ordererTLSHostnameOverride $ORDERER1_ADDRESS --tls $CORE_PEER_TLS_ENABLED \
  --cafile $ORDERER1_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME $PEER_CONN_PARMS \
  -c '{"Args":["invoke","a","b","1"]}'
