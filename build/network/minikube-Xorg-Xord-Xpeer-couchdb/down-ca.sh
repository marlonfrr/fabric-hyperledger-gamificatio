#!/bin/bash

kubectl delete configmap ca-orderer-server-config
kubectl -f ./k8s/ca-orderer.yaml delete

kubectl delete configmap ca-org1-server-config
kubectl -f ./k8s/ca-org1.yaml delete

kubectl delete configmap ca-org2-server-config
kubectl -f ./k8s/ca-org2.yaml delete


kubectl -f ./k8s/ca-orderer-pvc.yaml delete
kubectl -f ./k8s/ca-org1-pvc.yaml delete
kubectl -f ./k8s/ca-org2-pvc.yaml delete

# kubectl delete all --all
# kubectl delete pvc --all
