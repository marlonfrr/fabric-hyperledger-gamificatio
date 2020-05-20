#!/bin/bash

ORG="org1"
API="api1"
kubectl create configmap ${ORG}-${API}-wallet --from-file=./build/wallet/${ORG}-${API}/user3.id
kubectl create configmap ${ORG}-${API}-con --from-file=./build/wallet/${ORG}-${API}/connection.json
kubectl -f ./k8s/${ORG}-${API}.yaml create


kubectl create configmap ${ORG}-io-wallet --from-file=./build/wallet/${ORG}-${API}/user3.id
kubectl create configmap ${ORG}-io-con --from-file=./build/wallet/${ORG}-${API}/connection.json
kubectl -f ./k8s/${ORG}-io.yaml create
kubectl -f ./k8s/${ORG}-io-endpoint.yaml create

kubectl -f ./k8s/${ORG}-io-sns.yaml create

ORG="org2"
API="api1"
kubectl create configmap ${ORG}-${API}-wallet --from-file=./build/wallet/${ORG}-${API}/user3.id
kubectl create configmap ${ORG}-${API}-con --from-file=./build/wallet/${ORG}-${API}/connection.json
kubectl -f ./k8s/${ORG}-${API}.yaml create


kubectl create configmap ${ORG}-io-wallet --from-file=./build/wallet/${ORG}-${API}/user3.id
kubectl create configmap ${ORG}-io-con --from-file=./build/wallet/${ORG}-${API}/connection.json
kubectl -f ./k8s/${ORG}-io.yaml create
kubectl -f ./k8s/${ORG}-io-endpoint.yaml create
