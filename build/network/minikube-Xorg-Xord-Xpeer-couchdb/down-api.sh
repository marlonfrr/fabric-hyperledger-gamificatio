#!/bin/bash

ORG="org1"
API="api1"
kubectl -f ./k8s/${ORG}-${API}.yaml delete
kubectl delete configmap ${ORG}-${API}-wallet
kubectl delete configmap ${ORG}-${API}-con

kubectl delete configmap ${ORG}-io-wallet
kubectl delete configmap ${ORG}-io-con
kubectl -f ./k8s/${ORG}-io.yaml delete
kubectl -f ./k8s/${ORG}-io-endpoint.yaml delete
ORG="org2"
API="api1"
kubectl -f ./k8s/${ORG}-${API}.yaml delete
kubectl delete configmap ${ORG}-${API}-wallet
kubectl delete configmap ${ORG}-${API}-con

kubectl delete configmap ${ORG}-io-wallet
kubectl delete configmap ${ORG}-io-con
kubectl -f ./k8s/${ORG}-io.yaml delete
kubectl -f ./k8s/${ORG}-io-endpoint.yaml delete
