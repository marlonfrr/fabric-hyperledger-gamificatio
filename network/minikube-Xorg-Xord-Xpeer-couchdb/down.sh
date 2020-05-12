#!/bin/bash

ORDERER="orderer1"
kubectl -f ./k8s/${ORDERER}.yaml delete
kubectl delete configmap ${ORDERER}-msp
kubectl delete configmap ${ORDERER}-tls

ORDERER="orderer2"
kubectl -f ./k8s/${ORDERER}.yaml delete
kubectl delete configmap ${ORDERER}-msp
kubectl delete configmap ${ORDERER}-tls

ORDERER="orderer3"
kubectl -f ./k8s/${ORDERER}.yaml delete
kubectl delete configmap ${ORDERER}-msp
kubectl delete configmap ${ORDERER}-tls


kubectl delete configmap orderer-genesis

PEER="peer0"
ORG="org1"
kubectl -f ./k8s/${PEER}-${ORG}.yaml delete
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml delete
kubectl delete configmap ${PEER}-${ORG}-msp
kubectl delete configmap ${PEER}-${ORG}-tls
kubectl delete configmap ${PEER}-${ORG}-core

PEER="peer1"
ORG="org1"
kubectl -f ./k8s/${PEER}-${ORG}.yaml delete
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml delete
kubectl delete configmap ${PEER}-${ORG}-msp
kubectl delete configmap ${PEER}-${ORG}-tls
kubectl delete configmap ${PEER}-${ORG}-core

PEER="peer0"
ORG="org2"
kubectl -f ./k8s/${PEER}-${ORG}.yaml delete
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml delete
kubectl delete configmap ${PEER}-${ORG}-msp
kubectl delete configmap ${PEER}-${ORG}-tls
kubectl delete configmap ${PEER}-${ORG}-core

PEER="peer1"
ORG="org2"
kubectl -f ./k8s/${PEER}-${ORG}.yaml delete
kubectl -f ./k8s/${PEER}-${ORG}-couchdb.yaml delete
kubectl delete configmap ${PEER}-${ORG}-msp
kubectl delete configmap ${PEER}-${ORG}-tls
kubectl delete configmap ${PEER}-${ORG}-core



# kubectl delete all --all
# kubectl delete pvc --all

# kubectl -f ./k8s/storage-class.yaml delete
