#!/bin/bash

# https://kubernetes.io/docs/reference/kubectl/jsonpath/

mkdir ./build 2> /dev/null

declare -A IPS
IPS['ingress-myservicea']='false'

RES=$(kubectl get ing \
  -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.loadBalancer.ingress[0].ip}{"\n"}{end}')

# echo "$RES" > "./build/ca-ips.txt"

while read line ; do
  service=$(echo "$line" | sed 's/^\(\S\+\)\s*\(\S*\)/\1/g')
  ip=$(echo "$line" | sed 's/^\(\S\+\)\s*\(\S*\)/\2/g')

  if [[ -z "$ip" ]]; then
      continue
  fi
  if [[ -z "${IPS[$service]}" ]]; then
    continue
  fi

  IPS["$service"]="$ip"
done <<< "$RES"

NUM_DOWN=0
for s in "${!IPS[@]}"; do
  if [[ "${IPS[$s]}" == 'false' ]]; then
   NUM_DOWN=$(($NUM_DOWN + 1))
   echo "Down: $s"
  fi
done

if [[ "$NUM_DOWN" != "0" ]]; then
  echo "-----------"
  echo "TOTAL: $NUM_DOWN"
  exit 1
fi

FILE="./docker-compose/cli.yaml"
BACK="${FILE}.back"

TEXT=$( cat "$BACK" )
for s in "${!IPS[@]}"; do
  if [[ "$s" =~ ^ingress-myservicea ]]; then
    TEXT=$(echo "$TEXT" | sed "s/ca.example.com:192.168.99.100/ca.example.com:${IPS[$s]}/g")

    TEXT=$(echo "$TEXT" | sed "s/ca.org1.example.com:192.168.99.100/ca.org1.example.com:${IPS[$s]}/g")
    TEXT=$(echo "$TEXT" | sed "s/ca.org2.example.com:192.168.99.100/ca.org2.example.com:${IPS[$s]}/g")

    TEXT=$(echo "$TEXT" | sed "s/peer0.org1.example.com:192.168.99.100/peer0.org1.example.com:${IPS[$s]}/g")
    TEXT=$(echo "$TEXT" | sed "s/peer1.org1.example.com:192.168.99.100/peer1.org1.example.com:${IPS[$s]}/g")
    TEXT=$(echo "$TEXT" | sed "s/peer0.org2.example.com:192.168.99.100/peer0.org2.example.com:${IPS[$s]}/g")
    TEXT=$(echo "$TEXT" | sed "s/peer1.org2.example.com:192.168.99.100/peer1.org2.example.com:${IPS[$s]}/g")

    TEXT=$(echo "$TEXT" | sed "s/orderer1.example.com:192.168.99.100/orderer1.example.com:${IPS[$s]}/g")
    TEXT=$(echo "$TEXT" | sed "s/orderer2.example.com:192.168.99.100/orderer2.example.com:${IPS[$s]}/g")
    TEXT=$(echo "$TEXT" | sed "s/orderer3.example.com:192.168.99.100/orderer3.example.com:${IPS[$s]}/g")
  fi
done

echo "$TEXT" > "$FILE"
