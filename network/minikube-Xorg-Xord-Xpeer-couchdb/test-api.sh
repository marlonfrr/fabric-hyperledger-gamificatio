#!/bin/bash

URL=http://192.168.99.100:3000
echo "---"
curl -X GET ${URL}/v1/api/a -H  "accept: application/json"
echo ""
curl -X POST "${URL}/v1/api" -H  "accept: */*" \
  -H  "Content-Type: application/json" -d "{\"A\":\"a\",\"B\":\"b\",\"amount\":1}"
echo ""
curl -X GET ${URL}/v1/api/a -H  "accept: application/json"
echo ""

URL=http://192.168.99.100:3000
echo "---"
curl -X GET ${URL}/v1/api/a -H  "accept: application/json"
echo ""
curl -X POST "${URL}/v1/api" -H  "accept: */*" \
  -H  "Content-Type: application/json" -d "{\"A\":\"a\",\"B\":\"b\",\"amount\":1}"
echo ""
curl -X GET ${URL}/v1/api/a -H  "accept: application/json"
echo ""

