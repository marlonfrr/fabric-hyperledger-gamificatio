#!/bin/bash

export CHANNEL_NAME="mychannel"
export CORE_PEER_TLS_ENABLED="true"

export PEER0_ORG1_CA=${PWD}/build/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/build/organizations/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/build/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/build/organizations/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt

export ORDERER1_CA=${PWD}/build/organizations/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export ORDERER1_ADDRESS_PORT=orderer1.example.com:443
export ORDERER1_ADDRESS=orderer1.example.com

if [[ $1 == "1" && $2 == "0" ]]; then
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/build/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_ADDRESS=peer0.org1.example.com:443
elif [[ $1 == "1" && $2 == "1" ]]; then
  export CORE_PEER_LOCALMSPID="Org1MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/build/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
  export CORE_PEER_ADDRESS=peer1.org1.example.com:443
elif [[ $1 == "2" && $2 == "0" ]]; then
  export CORE_PEER_LOCALMSPID="Org2MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/build/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
  export CORE_PEER_ADDRESS=peer0.org2.example.com:443
elif [[ $1 == "2" && $2 == "1" ]]; then
  export CORE_PEER_LOCALMSPID="Org2MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/build/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
  export CORE_PEER_ADDRESS=peer1.org2.example.com:443
fi
