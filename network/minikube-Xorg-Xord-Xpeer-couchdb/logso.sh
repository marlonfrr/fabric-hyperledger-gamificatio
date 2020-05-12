#!/bin/bash

POD=$(kubectl get pods | grep orderer1- | cut -d" " -f 1,1)
kubectl logs -f pods/${POD}
