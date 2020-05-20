/*
 *  SPDX-License-Identifier: Apache-2.0
 */

'use strict';

// Bring key classes into scope, most importantly Fabric SDK network class
const fs = require('fs');
const { Wallets } = require('fabric-network');
const path = require('path');

const fixtures = path.resolve(__dirname, '../build/');

const ORG = process.argv[2];
const USER = process.argv[3];
const API = process.argv[4];
const MSP = process.argv[5];

async function main() {

  // Main try/catch block
  try {

    // A wallet stores a collection of identities
    const wallet = await Wallets.newFileSystemWallet('../build/wallet/'+ORG+'-'+API);

    // Identity to credentials to be stored in the wallet
    const credPath = path.join(fixtures, '/organizations/peerOrganizations/'+ORG+'.example.com/users/'+USER+'@'+ORG+'.example.com');
    const certificate = fs.readFileSync(path.join(credPath, '/msp/signcerts/'+USER+'@'+ORG+'.example.com-cert.pem')).toString();
    const privateKey = fs.readFileSync(path.join(credPath, '/msp/keystore/priv_sk')).toString();

    // Load credentials into wallet
    const identityLabel = 'user3';

    const identity = {
      credentials: {
        certificate,
        privateKey
      },
      mspId: MSP,
      type: 'X.509'
    };

    await wallet.put(identityLabel, identity);

  } catch (error) {
    console.log(`Error adding to wallet. ${error}`);
    console.log(error.stack);
  }
}

main().then(() => {
  console.log('done');
}).catch((e) => {
  console.log(e);
  console.log(e.stack);
  process.exit(-1);
});
