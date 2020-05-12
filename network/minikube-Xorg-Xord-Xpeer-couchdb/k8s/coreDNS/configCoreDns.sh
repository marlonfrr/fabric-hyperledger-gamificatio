#!/bin/bash
# https://docs.microsoft.com/en-us/azure/aks/coredns-custom
# https://stackoverflow.com/questions/53498438/how-do-i-force-kubernetes-coredns-to-reload-its-config-map-after-a-change
if [[ ! -f "./corednsms.yaml.backup" ]]; then
  kubectl get configmaps --namespace=kube-system coredns-custom -o yaml > corednsms.yaml.backup
fi

kubectl apply -f corednsms.yaml
kubectl get configmaps --namespace=kube-system coredns-custom -o yaml
kubectl delete pod --namespace kube-system -l k8s-app=kube-dns

#Edit manually
#kubectl edit cm coredns-custom -n kube-system
