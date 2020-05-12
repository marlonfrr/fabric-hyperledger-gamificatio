#!/bin/bash

curl -H "Content-Type: application/json" -X POST 192.168.99.100:31098/v1/userCreate --data '{"name":"David","id":"1200000000","age":24}'

curl -H "Content-Type: application/json" -X POST 192.168.99.100:31098/v1/userCreate --data '{"name":"Maria","id":"1300000000","age":24}'
