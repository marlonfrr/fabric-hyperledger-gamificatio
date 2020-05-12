'use strict';
require('dotenv').config();

const { Gateway, Wallets } = require('fabric-network');
// const fs = require('fs');
// const yaml = require('js-yaml');
const path = require('path');

let wallet;
let gateway;

gateway = new Gateway();


async function start(){
  const userName = 'user3';
  const channel = 'mychannel';
  // const ccpPath = path.resolve(__dirname, '.', 'connection-org1-azure.json');
  // const ccpPath = path.resolve(__dirname, '.', 'connection-org1-minikube.json');
  const ccpPath = path.resolve(__dirname, '.', 'connection.json');

  const walletPath = path.join(process.cwd(), 'wallet');
  wallet = await Wallets.newFileSystemWallet(walletPath);

  let identity = await wallet.get('user3');

  if (!identity) {
    console.log('An identity for the user "user3" does not exist in the wallet');
    console.log('Run the registerUser.js application before retrying');
    return;
  }

  if(process.env.LOCAL && process.env.LOCAL === 'false'){
    console.log('REMOTE');
    await gateway.connect(ccpPath,{
      wallet,
      identity:userName,
      discovery: { enabled: true, asLocalhost: false }
    });
  }
  else{
    console.log('LOCAL');
    await gateway.connect(ccpPath, {
      wallet,
      identity: userName,
      discovery: { enabled: true, asLocalhost: true }
    });
  }

  const network = await gateway.getNetwork(channel);

  return {gateway:gateway, network: network};
}

module.exports = start();
