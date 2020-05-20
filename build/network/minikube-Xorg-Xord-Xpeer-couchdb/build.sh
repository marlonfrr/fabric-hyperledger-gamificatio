#!/bin/bash

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli.yaml run \
  --rm cli bash ./cli/buildGenesis.sh

#Wallet
rm -rf ./build/wallet
mkdir -p ./build/wallet/

#---
ORG="org1"
USER="User1"
API="api1"
MSP="Org1MSP"

cert="./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/signcerts/*"
mv $cert "./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/signcerts/${USER}@${ORG}.example.com-cert.pem"

priv_key="./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/keystore/*"
mv $priv_key "./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/keystore/priv_sk"

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli-wallet.yaml \
  run --rm cli-wallet bash -c "
  npm install
  node ./addToWallet.js ${ORG} ${USER} ${API} ${MSP}
"

cp ./build/organizations/peerOrganizations/${ORG}.example.com/connection-${ORG}.json \
  ./build/wallet/${ORG}-${API}/connection.json

#---
ORG="org2"
USER="User1"
API="api1"
MSP="Org2MSP"

cert="./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/signcerts/*"
mv $cert "./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/signcerts/${USER}@${ORG}.example.com-cert.pem"

priv_key="./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/keystore/*"
mv $priv_key "./build/organizations/peerOrganizations/${ORG}.example.com/users/${USER}@${ORG}.example.com/msp/keystore/priv_sk"

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli-wallet.yaml \
  run --rm cli-wallet bash -c "
  npm install
  node ./addToWallet.js ${ORG} ${USER} ${API} ${MSP}
"

cp ./build/organizations/peerOrganizations/${ORG}.example.com/connection-${ORG}.json \
  ./build/wallet/${ORG}-${API}/connection.json

#---

#Copy to app
rm -rf ../../apps/build/
mkdir -p ../../apps/build/
cp -r ./build/wallet/ ../../apps/build/
