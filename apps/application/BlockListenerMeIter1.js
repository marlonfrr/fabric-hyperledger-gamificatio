'use strict';

const getGateway = require('./gateway/gateway');
const util = require('util');
const request = require('request');
const path = require('path');
const configPath = path.resolve(__dirname, 'nextblock.txt');
const fs = require('fs');
const blockProcessing = require('./BlockProcessing.js');
const config = require('./config.json');
const channelid = config.channelid;
const peer_name = config.peer_name;
const use_couchdb = config.use_couchdb;

var options = {
  method: 'POST',
  url: 'http://localhost:8080/newBlock',
  headers: {
    'cache-control': 'no-cache',
    'Content-Type': 'application/json',
  },
  body: { block_number: 1 },
  json: true,
};

class BlockMap {
  constructor() {
    this.list = [];
  }
  get(key) {
    key = parseInt(key, 10).toString();
    return this.list[`block${key}`];
  }
  set(key, value) {
    this.list[`block${key}`] = value;
  }
  remove(key) {
    key = parseInt(key, 10).toString();
    delete this.list[`block${key}`];
  }
}

let ProcessingMap = new BlockMap();
let nextBlock = 0;
if (fs.existsSync(configPath)) {
  // read file containing the next block to read
  nextBlock = fs.readFileSync(configPath, 'utf8');
} else {
  // store the next block as 0
  fs.writeFileSync(configPath, parseInt(nextBlock, 10));
}

let gate;
getGateway
  .then(async ({ gateway, network }) => {
    gate = gateway;
    const contract = network.getContract('fabcar');
    // await contract.submitTransaction('invoke', '1', '3', '1');

    const network2 = await gateway.getNetwork('mychannel');

    const listenerB = await network.addBlockListener(
      'my-block-listener-NUEVITO',
      async (error, block) => {
        if (error) {
          console.error(error);
          return;
        }

        console.log(
          '*************** start block header **********************'
        );
        console.log(
          util.inspect(block.header, { showHidden: false, depth: 5 })
        );
        console.log('*************** end block header **********************');
        options.body = new Object();
        options.body.blockHeader = block.header;
        options.body.block_number = block.header.number;
        await ProcessingMap.set(block.header.number, block);
        request(options, function (error, response, body) {
          if (error) {
            throw new Error(error);
          }
          /*console.log(body);*/
        });
      },
      {
        filtered: false,
        startBlock: parseInt(
          nextBlock,
          10
        ) /* ,
       eventHubConnectWait: 100000,
        eventHubConnectTimeout: 100000,*/,
      }
    );
    processPendingBlocks(ProcessingMap);

    //  await contract.submitTransaction('invoke', '1', '3', '1');
  })
  .catch((error) => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
    console.log(`whats going on`);

    ///  console.log(ProcessingMap.get(10));
  })
  .finally(() => {
    setTimeout(() => {
      gate.disconnect();
    }, 3000000);
  });

setTimeout(() => {
  console.log('lastly');
  ///console.log(util.inspect(ProcessingMap.get(10)));
  /// processPendingBlocks(ProcessingMap);
}, 25000);
async function processPendingBlocks(ProcessingMap) {
  setTimeout(async () => {
    let nextBlockNumber = fs.readFileSync(configPath, 'utf8');
    let processBlock;
    do {
      processBlock = ProcessingMap.get(nextBlockNumber);
      if (processBlock == undefined) {
        break;
      }
      try {
        await blockProcessing.processBlockEvent(
          channelid,
          processBlock,
          false,
          null
        );
      } catch (error) {
        console.error(`Failed to process block: ${error}`);
      }
      ProcessingMap.remove(nextBlockNumber);
      fs.writeFileSync(configPath, parseInt(nextBlockNumber, 10) + 1);
      nextBlockNumber = fs.readFileSync(configPath, 'utf8');
    } while (true);
    processPendingBlocks(ProcessingMap);
  }, 250);
}
