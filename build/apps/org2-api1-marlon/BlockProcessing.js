'use strict';

const fs = require('fs');
const path = require('path');
const request = require('request');

const configPath = path.resolve(__dirname, 'nextblock.txt');
var options = {
  method: 'POST',
  url: 'http://localhost:8080/newTransactionWatched',
  headers: {
    'cache-control': 'no-cache',
    'Content-Type': 'application/json',
  },
  body: { more_info: 1, block_number: 1 },
  json: true,
};

exports.processBlockEvent = async function (
  channelname,
  block,
  use_couchdb,
  nano
) {
  return new Promise(async (resolve, reject) => {
    // reject the block if the block number is not defined
    if (block.header.number == undefined) {
      reject(new Error('Undefined block number'));
    }

    const blockNumber = block.header.number;

    console.log(`------------------------------------------------`);
    console.log(`Block Number: ${blockNumber}`);

    // reject if the data is not set
    if (block.data.data == undefined) {
      reject(new Error('Data block is not defined'));
    }

    const dataArray = block.data.data;

    // transaction filter for each transaction in dataArray
    const txSuccess = block.metadata.metadata[2];

    for (var dataItem in dataArray) {
      // reject if a timestamp is not set
      //data item is a transaction
      if (
        dataArray[dataItem].payload.header.channel_header.timestamp == undefined
      ) {
        reject(new Error('Transaction timestamp is not defined'));
      }
      console.log(
        'there is just one  dataItem in dataArray. Since there is just one transaction in the block'
      );
      console.log('-------------------------------');
      // tx may be rejected at commit stage by peers
      // only valid transactions (code=0) update the word state and off-chain db
      // filter through valid tx, refer below for list of error codes
      // https://github.com/hyperledger/fabric-sdk-node/blob/release-1.4/fabric-client/lib/protos/peer/transaction.proto
      if (txSuccess[dataItem] !== 0) {
        continue;
      }

      const timestamp =
        dataArray[dataItem].payload.header.channel_header.timestamp;

      // continue to next tx if no actions are set
      if (dataArray[dataItem].payload.data.actions == undefined) {
        continue;
      }

      // actions are stored as an array. In Fabric 1.4.3 only one
      // action exists per tx so we may simply use actions[0]
      // in case Fabric adds support for multiple actions
      // a for loop is used for demonstration
      const actions = dataArray[dataItem].payload.data.actions;
      //actions are the acctions taht are done in each transaction
      // iterate through all actions
      for (var actionItem in actions) {
        // reject if a chaincode id is not defined
        console.log('there is just one  actionItem  in actions. Since');
        console.log('-------------------------------');
        if (
          actions[actionItem].payload.chaincode_proposal_payload.input
            .chaincode_spec.chaincode_id.name == undefined
        ) {
          reject(new Error('Chaincode name is not defined'));
        }

        const chaincodeID =
          actions[actionItem].payload.chaincode_proposal_payload.input
            .chaincode_spec.chaincode_id.name;

        // reject if there is no readwrite set
        if (
          actions[actionItem].payload.action.proposal_response_payload.extension
            .results.ns_rwset == undefined
        ) {
          reject(new Error('No readwrite set is defined'));
        }

        const rwSet =
          actions[actionItem].payload.action.proposal_response_payload.extension
            .results.ns_rwset;
        ///rwSET es la respuesta en los resultados dados
        for (var record in rwSet) {
          // ignore lscc events
          console.log('there is one more record in rwSET');
          console.log('-------------------------------');

          if (
            rwSet[record].namespace != 'lscc' &&
            Array.isArray(rwSet[record].rwset.writes) &&
            rwSet[record].rwset.writes.length != 0
          ) {
            // create object to store properties
            const writeObject = new Object();
            writeObject.blocknumber = blockNumber;
            writeObject.chaincodeid = chaincodeID;
            writeObject.timestamp = timestamp;
            writeObject.values = rwSet[record].rwset.writes;

            console.log(`Transaction Timestamp: ${writeObject.timestamp}`);
            console.log(`ChaincodeID: ${writeObject.chaincodeid}`);
            console.log(writeObject.values);

            options.body = writeObject;

            request(options, function (error, response, body) {
              if (error) {
                throw new Error(error);
              }

              console.log(body);
            });

            //const logfilePath = path.resolve(__dirname, 'nextblock.txt');

            // send the object to a log file
            fs.appendFileSync(
              channelname + '_' + chaincodeID + '.log',
              JSON.stringify(writeObject) + '\n'
            );

            // if couchdb is configured, then write to couchdb
            if (use_couchdb) {
              try {
                console.log('e');
                // await writeValuesToCouchDBP(nano, channelname, writeObject);
              } catch (error) {
                console.log(error);
              }
            }
          }
        }
      }
    }

    // update the nextblock.txt file to retrieve the next block.IS ALREADY UP
    fs.writeFileSync(configPath, parseInt(blockNumber, 10) + 1);

    resolve(true);
  });
};

function isJSON(value) {
  try {
    JSON.parse(value);
  } catch (e) {
    return false;
  }
  return true;
}
