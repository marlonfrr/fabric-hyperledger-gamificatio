# Fabric 2.0.0 Hello World (Node.js)

## Deploying sample app in development mode ([no TLS](https://hyperledger-fabric.readthedocs.io/en/latest/chaincode4ade.html#terminal-1-start-the-network), 1 Org, Peer running in dev mode, CouchDB, and solo orderer)

To deploy the fabric network, in the `network` directory run:
```bash
./start.sh
```

In `smartcontracts/contract` run
```bash
npm install
```

To install the smart contract in `smartcontracts/contract`, in the `smartcontracts` directory run:
```bash
./deploy.sh

```
At the end something like the following should appear:

```bash
===========================
RUN:
===========================
CORE_CHAINCODE_ID_NAME=fabcar_1:3e4857d57fc322fd8eba0b1d4e21a03446f74f895dfa2228a874c8331f1dea72 CORE_PEER_TLS_ENABLED=false node ./contract/index.js --peer.address 127.0.0.1:7052

```
Run that command so that the smart contract in the `smartcontracts/contract` runs in development mode. Logs should appear in that terminal.

Then to initialize the smart contract in the `smartcontracts` directory run:
```bash
./initChaincode.sh

```

To run the application that connects to fabric in `apps/application` run:
```bash
npm install
node ./enrollAdmin.js
node ./registerUser.js

node ./query.js
node ./invoke.js
```

Then to start express web server on `port:3000` use:
```bash
npm start
```
The Swagger documentation will be in `/api-docs`
Fauxton (to view CouchDB) will be in port`:5984/_utils/`


To stop the fabric network in `network` run (in some cases it might require sudo):
```bash
./stop.sh
```

## Deploying sample app with 1 or 2 Organizations (TLS enabled, CouchDB, and etcd orderer)
Like deploying in dev mode except the scripts receive a flag `-n 1` or `-n 2` indicating the number of organizations in the network.

In `network`:
```bash
./start.sh -n 2
```

In `smartcontracts`:
```bash
./deploy.sh -n 2
./logs.sh
```

In `apps/application`:
```bash
npm install
node ./enrollAdmin.js
node ./registerUser.js

node ./query.js
node ./invoke.js
npm start
```
In `network`:
```bash
./stop.sh -n 2
```

## Useful docs

* [Hyperledger Fabric v2.0](https://hyperledger-fabric.readthedocs.io/en/latest/whatsnew.html)
* [Hyperledger Fabric Samples](https://github.com/hyperledger/fabric-samples)
* [Fabric SDK Node](https://hyperledger.github.io/fabric-sdk-node/release-1.4/index.html)
* [Fabric Chaincode node](https://hyperledger.github.io/fabric-chaincode-node/release-2.0/api/)
* [Swagger](https://swagger.io/docs/)
* [Fauxton](https://docs.couchdb.org/en/master/fauxton/index.html)


## References
This project was based on the [Fabric Samples](https://github.com/hyperledger/fabric-samples), specifically the test-network and the chaincode/fabcar/javascript examples of the [FAB-17498 commit](https://github.com/hyperledger/fabric-samples/commit/965ed1fa843a78e16fd0c33dcc0d980cfcef2e3f). It uses Fabric SDK Node 2.0.0-beta.2, which is not stable.
