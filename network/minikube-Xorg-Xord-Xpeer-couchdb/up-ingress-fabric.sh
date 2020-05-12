#!/bin/bash

#https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml

kubectl -f ./k8s/ingress/ingress-fabric.yaml create
