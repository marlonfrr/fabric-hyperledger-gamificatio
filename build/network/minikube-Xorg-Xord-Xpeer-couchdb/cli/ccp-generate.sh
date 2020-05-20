#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        $6
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        $6 | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=1
P0PORT=443
CAPORT=443
PEERPEM=./build/organizations/peerOrganizations/org${ORG}.example.com/tlsca/tlsca.org${ORG}.example.com-cert.pem
CAPEM=./build/organizations/peerOrganizations/org${ORG}.example.com/ca/ca.org${ORG}.example.com-cert.pem

TEMPLATE=cli/ccp-template.json
echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $TEMPLATE)" > \
  ./build/organizations/peerOrganizations/org${ORG}.example.com/connection-org${ORG}.json

ORG=2
P0PORT=443
CAPORT=443
PEERPEM=./build/organizations/peerOrganizations/org${ORG}.example.com/tlsca/tlsca.org${ORG}.example.com-cert.pem
CAPEM=./build/organizations/peerOrganizations/org${ORG}.example.com/ca/ca.org${ORG}.example.com-cert.pem

TEMPLATE=cli/ccp-template.json
echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $TEMPLATE)" > \
  ./build/organizations/peerOrganizations/org${ORG}.example.com/connection-org${ORG}.json

