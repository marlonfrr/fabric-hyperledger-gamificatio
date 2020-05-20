#!/bin/bash

#https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml

#Works only on ports 443 and 80

# kubectl get all --namespace ingress-nginx
kubectl -f ./k8s/ingress/ingress-controller.yaml create
