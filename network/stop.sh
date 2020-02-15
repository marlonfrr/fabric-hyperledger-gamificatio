#!/bin/bash -x

main() {
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
    stopN2
  elif [[ "$NETWORK" -eq 1 ]]; then
    stopN1
  else
    stopN0
  fi

  return 0
  #Stop containers
  # docker rm -f $(docker ps -aq)

  #Remove images
  # docker rmi -f $(docker images | grep papercontract | awk '{print $3}')
  # docker rmi -f $(docker images | grep dev- | awk '{print $3}')

  #===========================
  #If user error

  # docker volume prune -f
  # cd ./net0/test-network/organizations/fabric-ca/ordererOrg
  # rm -rf ./*
  # cd -
  #
  # cd ./net0/test-network/organizations/fabric-ca/org1
  # rm -rf ./*
  # cd -
  #
  # cd ./net0/test-network/organizations/fabric-ca/org2
  # rm -rf ./*
  # cd -
  #===========================
}

stopN0(){
  cd ./net0/test-network
  rm -rf organizations/peerOrganizations
  rm -rf organizations/ordererOrganizations
  rm -rf organizations/fabric-ca/ordererOrg/*
  rm -rf organizations/fabric-ca/org1/*
  ./network.sh down
  cd -
}

stopN1(){
  cd ./net1/test-network
  rm -rf organizations/peerOrganizations
  rm -rf organizations/ordererOrganizations
  rm -rf organizations/fabric-ca/ordererOrg/*
  rm -rf organizations/fabric-ca/org1/*
  ./network.sh down
  cd -
}

stopN2(){
  cd ./net2/test-network
  rm -rf organizations/peerOrganizations
  rm -rf organizations/ordererOrganizations
  rm -rf organizations/fabric-ca/ordererOrg/*
  rm -rf organizations/fabric-ca/org1/*
  ./network.sh down
  cd -
}

main "$@"
