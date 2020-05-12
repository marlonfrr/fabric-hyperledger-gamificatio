#!/bin/bash

# https://kubernetes.io/docs/reference/kubectl/jsonpath/

mkdir ./build 2> /dev/null

declare -A IPS

IPS['orderer1-nodeport']='false'
IPS['orderer2-nodeport']='false'
IPS['orderer3-nodeport']='false'

IPS['peer0-org1-nodeport']='false'
IPS['peer1-org1-nodeport']='false'
IPS['peer0-org2-nodeport']='false'
IPS['peer1-org2-nodeport']='false'


RES=$(kubectl get services \
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
  if [[ "$s" =~ ^ca-orderer- ]]; then
    TEXT=$(echo "$TEXT" | sed "s/ca.example.com:192.168.99.100/ca.example.com:${IPS[$s]}/g")
  elif [[ "$s" =~ ^ca-org[0-9]*- ]]; then
    ORG=$(echo "$s" | sed 's/ca-org\([0-9]*\).*/\1/g')
    TEXT=$(echo "$TEXT" | sed "s/ca.org${ORG}.example.com:192.168.99.100/ca.org${ORG}.example.com:${IPS[$s]}/g")
  elif [[ "$s" =~ ^peer[[:digit:]]*-org[[:digit:]]*-*- ]]; then
    ORG=$(echo "$s" | sed 's/peer\([0-9]\+\)-org\([0-9]\+\).*/\2/g')
    PEER=$(echo "$s" | sed 's/peer\([0-9]\+\)-org\([0-9]\+\).*/\1/g')
    TEXT=$(echo "$TEXT" | sed "s/peer${PEER}.org${ORG}.example.com:192.168.99.100/peer${PEER}.org${ORG}.example.com:${IPS[$s]}/g")
  elif [[ "$s" =~ ^orderer[[:digit:]]*-*- ]]; then
    NUM=$(echo "$s" | sed 's/^orderer\([0-9]\+\).*/\1/g')
    TEXT=$(echo "$TEXT" | sed "s/orderer${NUM}.example.com:192.168.99.100/orderer${NUM}.example.com:${IPS[$s]}/g")
  fi
done

echo "$TEXT" > "$FILE"
