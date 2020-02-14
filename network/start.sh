#!/bin/bash

startN0(){
  # ./stop.sh -n 0
  cd ./net0/test-network
  ./network.sh up createChannel -ca -c mychannel -s couchdb
  # ./network.sh createChannel -ca -c mychannel -s couchdb
  cd -

  cp ./net0/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.json ../apps/application/gateway
}

startN2(){
  # ./stop.sh -n 2
  cd ./net2/test-network
  ./network.sh up createChannel -ca -c mychannel -s couchdb
  # ./network.sh createChannel -ca -c mychannel -s couchdb
  cd -

  cp ./net2/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.json ../apps/application/gateway
}

#Parse flags

NETWORK=0
while [[ $# -ge 1 ]]; do
  k="$1"
  case $k in
    -n )
      NETWORK=$2
      shift
      ;;
    * )
      exit
      ;;
  esac
  shift
done

echo $NETWORK

if [[ "$NETWORK" -eq 2 ]]; then
  startN2
else
  startN0
fi



# Fauxton
# http://localhost:5984/_utils/
