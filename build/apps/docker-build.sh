#!/bin/bash

API="org1-api1-marlon"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -

API="org1-io"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -

API="org1-io-endpoint"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -

API="org1-io-sns-marlon"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -

API="org2-api1-marlon"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -

API="org2-io"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -

API="org2-io-endpoint"
cd ./${API}
docker build -t le999/${API}:1.0 .
cd -
