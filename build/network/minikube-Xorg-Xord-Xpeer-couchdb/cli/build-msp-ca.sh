function main() {
  createOrg 1 443 2
  createOrg 2 443 2
  createOrderer 443
}

function createOrg {
  ORG="org${1}"
  PORT=$2
  NUM_PEERS=$3

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/peerOrganizations/${ORG}.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/${ORG}.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@ca.${ORG}.example.com:${PORT} --caname ca-${ORG} --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
  set +x

  echo "NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-${ORG}-example-com-${PORT}-ca-${ORG}.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-${ORG}-example-com-${PORT}-ca-${ORG}.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-${ORG}-example-com-${PORT}-ca-${ORG}.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-${ORG}-example-com-${PORT}-ca-${ORG}.pem
    OrganizationalUnitIdentifier: orderer" > ${PWD}/organizations/peerOrganizations/${ORG}.example.com/msp/config.yaml

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca-${ORG} --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca-${ORG} --id.name ${ORG}admin --id.secret ${ORG}adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
  set +x


  peers=()
  for i in $(seq 0 $(( "$NUM_PEERS" - 1 ))); do
    peers+=("peer$i")
  done


  for PEER in ${peers[@]}; do

    echo
  	echo "Register ${PEER}"
    echo
    set -x
  	fabric-ca-client register --caname ca-${ORG} --id.name ${PEER} --id.secret ${PEER}pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
    set +x

  	mkdir -p organizations/peerOrganizations/${ORG}.example.com/peers
    mkdir -p organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com

    echo
    echo "## Generate the ${PEER} msp"
    echo
    set -x
  	fabric-ca-client enroll -u https://${PEER}:${PEER}pw@ca.${ORG}.example.com:${PORT} --caname ca-${ORG} -M ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/msp --csr.hosts ${PEER}.${ORG}.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
    set +x

    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/msp/config.yaml

    echo
    echo "## Generate the ${PEER}-tls certificates"
    echo
    set -x
    fabric-ca-client enroll -u https://${PEER}:${PEER}pw@ca.${ORG}.example.com:${PORT} --caname ca-${ORG} -M ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls --enrollment.profile tls --csr.hosts ${PEER}.${ORG}.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
    set +x


    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/ca.crt
    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/server.crt
    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/server.key

    mkdir ${PWD}/organizations/peerOrganizations/${ORG}.example.com/msp/tlscacerts
    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/${ORG}.example.com/msp/tlscacerts/ca.crt

    mkdir ${PWD}/organizations/peerOrganizations/${ORG}.example.com/tlsca
    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/${ORG}.example.com/tlsca/tlsca.${ORG}.example.com-cert.pem

    mkdir ${PWD}/organizations/peerOrganizations/${ORG}.example.com/ca
    cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/peers/${PEER}.${ORG}.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/${ORG}.example.com/ca/ca.${ORG}.example.com-cert.pem

  done

  mkdir -p organizations/peerOrganizations/${ORG}.example.com/users
  mkdir -p organizations/peerOrganizations/${ORG}.example.com/users/User1@${ORG}.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@ca.${ORG}.example.com:${PORT} --caname ca-${ORG} -M ${PWD}/organizations/peerOrganizations/${ORG}.example.com/users/User1@${ORG}.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
  set +x

  mkdir -p organizations/peerOrganizations/${ORG}.example.com/users/Admin@${ORG}.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://${ORG}admin:${ORG}adminpw@ca.${ORG}.example.com:${PORT} --caname ca-${ORG} -M ${PWD}/organizations/peerOrganizations/${ORG}.example.com/users/Admin@${ORG}.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/${ORG}/tls-cert.pem
  set +x

  cp ${PWD}/organizations/peerOrganizations/${ORG}.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/${ORG}.example.com/users/Admin@${ORG}.example.com/msp/config.yaml

}

function createOrderer {

  PORT=$1

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p organizations/ordererOrganizations/example.com

	export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@ca.example.com:${PORT} --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  echo "NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca-example-com-${PORT}-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca-example-com-${PORT}-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca-example-com-${PORT}-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca-example-com-${PORT}-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer" > ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml


  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  for ORDERER in "orderer1" "orderer2" "orderer3"; do

    echo
  	echo "Register orderer"
    echo
    set -x
  	fabric-ca-client register --caname ca-orderer --id.name ${ORDERER} --id.secret ${ORDERER}pw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

    mkdir -p organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com

    echo
    echo "## Generate the orderer msp"
    echo
    set -x
  	fabric-ca-client enroll -u https://${ORDERER}:${ORDERER}pw@ca.example.com:${PORT} --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp --csr.hosts ${ORDERER}.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

    cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/config.yaml

    echo
    echo "## Generate the orderer-tls certificates"
    echo
    set -x
    fabric-ca-client enroll -u https://${ORDERER}:${ORDERER}pw@ca.example.com:${PORT} --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls --enrollment.profile tls --csr.hosts ${ORDERER}.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
    set +x

    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/ca.crt
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/server.crt
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/server.key

    mkdir ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

    mkdir ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
    cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/${ORDERER}.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem
  done

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com



  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@ca.example.com:${PORT} --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  set +x

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml


}

main "$@"
