#!/bin/bash

kubectl -f ./k8s/storage-class.yaml delete
kubectl -f ./k8s/storage-class.yaml create

kubectl create configmap ca-orderer-server-config \
  --from-file=./fabric/ca/ordererOrg/fabric-ca-server-config.yaml

kubectl create configmap ca-org1-server-config \
  --from-file=./fabric/ca/org1/fabric-ca-server-config.yaml

kubectl create configmap ca-org2-server-config \
  --from-file=./fabric/ca/org2/fabric-ca-server-config.yaml


kubectl -f ./k8s/ca-orderer-pvc.yaml create
kubectl -f ./k8s/ca-orderer.yaml create

kubectl -f ./k8s/ca-org1-pvc.yaml create
kubectl -f ./k8s/ca-org1.yaml create

kubectl -f ./k8s/ca-org2-pvc.yaml create
kubectl -f ./k8s/ca-org2.yaml create

