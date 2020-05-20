#!/bin/bash

kubectl -f ./k8s/storage-class.yaml create

cp ./build/system-genesis-block/genesis.block ./build/system-genesis-block/orderer.genesis.block
kubectl create configmap orderer-genesis --from-file=./build/system-genesis-block/orderer.genesis.block

#Orderer
ORDERER="orderer1"
cd ./build/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${ORDERER}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${ORDERER}-tls --from-file=./tls.tar.gz
cd -
kubectl -f ./k8s/${ORDERER}.yaml create

ORDERER="orderer2"
cd ./build/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${ORDERER}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${ORDERER}-tls --from-file=./tls.tar.gz
cd -
kubectl -f ./k8s/${ORDERER}.yaml create

ORDERER="orderer3"
cd ./build/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${ORDERER}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${ORDERER}-tls --from-file=./tls.tar.gz
cd -
kubectl -f ./k8s/${ORDERER}.yaml create


ORG="org1"
PEER="peer0"
cd ./build/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${PEER}-${ORG}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${PEER}-${ORG}-tls --from-file=./tls.tar.gz
cd -
kubectl create configmap ${PEER}-${ORG}-core --from-file=./fabric/peer/${ORG}/${PEER}/core.yaml
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml create
kubectl -f ./k8s/${PEER}-${ORG}.yaml create

ORG="org1"
PEER="peer1"
cd ./build/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${PEER}-${ORG}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${PEER}-${ORG}-tls --from-file=./tls.tar.gz
cd -
kubectl create configmap ${PEER}-${ORG}-core --from-file=./fabric/peer/${ORG}/${PEER}/core.yaml
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml create
kubectl -f ./k8s/${PEER}-${ORG}.yaml create

ORG="org2"
PEER="peer0"
cd ./build/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${PEER}-${ORG}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${PEER}-${ORG}-tls --from-file=./tls.tar.gz
cd -
kubectl create configmap ${PEER}-${ORG}-core --from-file=./fabric/peer/${ORG}/${PEER}/core.yaml
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml create
kubectl -f ./k8s/${PEER}-${ORG}.yaml create

ORG="org2"
PEER="peer1"
cd ./build/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/
  tar -C ./ -czvf ./msp.tar.gz msp
  kubectl create configmap ${PEER}-${ORG}-msp --from-file=./msp.tar.gz
  tar -C ./ -czvf ./tls.tar.gz tls
  kubectl create configmap ${PEER}-${ORG}-tls --from-file=./tls.tar.gz
cd -
kubectl create configmap ${PEER}-${ORG}-core --from-file=./fabric/peer/${ORG}/${PEER}/core.yaml
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml create
kubectl -f ./k8s/${PEER}-${ORG}.yaml create

