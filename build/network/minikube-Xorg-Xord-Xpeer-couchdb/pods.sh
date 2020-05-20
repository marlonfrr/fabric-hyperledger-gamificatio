#!/bin/bash

# https://kubernetes.io/docs/reference/kubectl/jsonpath/

RES=$(kubectl get pods \
  -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}')

NUM_PODS=$(echo "$RES"  | wc -l)
NUM_PODS_RUNNING=$(echo "$RES" | cut -f2 | grep 'Running' | wc -l)
echo "(${NUM_PODS_RUNNING}/${NUM_PODS}) Running Pods"
