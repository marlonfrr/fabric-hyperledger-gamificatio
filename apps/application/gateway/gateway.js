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
  let userName;
  let channel;
  let ccpPath = '';

  if(process.env.LOCAL && process.env.LOCAL === 'false'){
    // wallet = new FileSystemWallet('./wallet');
    // userName = 'user1';
    // channel = 'channel1';
    // console.log('REMOTE');
    // connectionProfile = JSON.parse(fs.readFileSync('./channel1_donorContract_profile.json', 'utf8'));
    // connectionOptions = {
    //   identity: userName,
    //   wallet: wallet,
    //   discovery: { enabled:true, asLocalhost: false }
    // };
  }
  else{
    ccpPath = path.resolve(__dirname, '.', 'connection-org1.json');

    const walletPath = path.join(process.cwd(), 'wallet');
    wallet = await Wallets.newFileSystemWallet(walletPath);

    userName = 'user3';

    let identity = await wallet.get(userName);
    if (!identity) {
      console.log('An identity for the user "user2" does not exist in the wallet');
      console.log('Run the registerUser.js application before retrying');
      return;
    }

    channel = 'mychannel';
    console.log('LOCAL');
  }
  await gateway.connect(ccpPath, { wallet, identity: userName, discovery: { enabled: true, asLocalhost: true } });

  const network = await gateway.getNetwork(channel);

  return {gateway:gateway, network: network};

}

module.exports = start();
