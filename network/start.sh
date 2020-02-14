#!/bin/bash

main(){
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
  elif [[ "$NETWORK" -eq 1 ]]; then
    startN1
  else
    startN0
  fi


  # Fauxton
  # http://localhost:5984/_utils/
}

startN0(){
  # ./stop.sh -n 0
  cd ./net0/test-network
  ./network.sh up createChannel -ca -c mychannel -s couchdb
  # ./network.sh createChannel -ca -c mychannel -s couchdb
  cd -

  cp ./net0/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.json ../apps/application/gateway
}

startN1(){
  # ./stop.sh -n 0
  cd ./net1/test-network
  ./network.sh up createChannel -ca -c mychannel -s couchdb
  # ./network.sh createChannel -ca -c mychannel -s couchdb
  cd -

  cp ./net1/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.json ../apps/application/gateway
}

startN2(){
  # ./stop.sh -n 2
  cd ./net2/test-network
  ./network.sh up createChannel -ca -c mychannel -s couchdb
  # ./network.sh createChannel -ca -c mychannel -s couchdb
  cd -

  cp ./net2/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.json ../apps/application/gateway
}

main "$@"
