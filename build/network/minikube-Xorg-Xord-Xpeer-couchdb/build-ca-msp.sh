#!/bin/bash

rm -r ./build

mkdir -p ./build/organizations/fabric-ca/ordererOrg/
CA_POD=$(kubectl get pods | grep ca-orderer- | cut -d" " -f 1,1)
kubectl cp $CA_POD:/etc/hyperledger/fabric-ca-server/tls-cert.pem ./build/organizations/fabric-ca/ordererOrg/tls-cert.pem

mkdir -p ./build/organizations/fabric-ca/org1/
CA_POD=$(kubectl get pods | grep ca-org1- | cut -d" " -f 1,1)
kubectl cp $CA_POD:/etc/hyperledger/fabric-ca-server/tls-cert.pem ./build/organizations/fabric-ca/org1/tls-cert.pem

mkdir -p ./build/organizations/fabric-ca/org2/
CA_POD=$(kubectl get pods | grep ca-org2- | cut -d" " -f 1,1)
kubectl cp $CA_POD:/etc/hyperledger/fabric-ca-server/tls-cert.pem ./build/organizations/fabric-ca/org2/tls-cert.pem


CURRENT_UID=$(id -u):$(id -g) docker-compose -f ./docker-compose/cli-build-ca.yaml run \
  --rm cli bash ../cli/build-msp-ca.sh
