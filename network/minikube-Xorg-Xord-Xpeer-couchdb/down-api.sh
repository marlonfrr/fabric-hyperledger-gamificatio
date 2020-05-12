#!/bin/bash

ORG="org1"
API="api1"
kubectl -f ./k8s/${ORG}-${API}.yaml delete
kubectl delete configmap ${ORG}-${API}-wallet
kubectl delete configmap ${ORG}-${API}-con

ORG="org2"
API="api1"
kubectl -f ./k8s/${ORG}-${API}.yaml delete
kubectl delete configmap ${ORG}-${API}-wallet
kubectl delete configmap ${ORG}-${API}-con

