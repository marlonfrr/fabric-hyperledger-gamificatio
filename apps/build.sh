#!/bin/bash

ORG="org1"
API="api1"
USER="user3"
cp ./build/wallet/${ORG}-${API}/connection.json ./${ORG}-${API}/gateway/connection.json
rm -rf ./${ORG}-${API}/wallet
mkdir -p ./${ORG}-${API}/wallet
cp ./build/wallet/${ORG}-${API}/${USER}.id ./${ORG}-${API}/wallet/${USER}.id

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose-${ORG}-${API}.yaml \
  run --rm api-server bash -c "
  npm install

  node ./query.js
  node ./invoke.js
  node ./query.js
"

ORG="org2"
API="api1"
USER="user3"
cp ./build/wallet/${ORG}-${API}/connection.json ./${ORG}-${API}/gateway/connection.json
rm -rf ./${ORG}-${API}/wallet
mkdir -p ./${ORG}-${API}/wallet
cp ./build/wallet/${ORG}-${API}/${USER}.id ./${ORG}-${API}/wallet/${USER}.id

CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose-${ORG}-${API}.yaml \
  run --rm api-server bash -c "
  npm install

  node ./query.js
  node ./invoke.js
  node ./query.js
"

