'use strict';
const getGateway = require('./gateway/gateway');
const util = require('util');
const request = require('request');
const path = require('path');
const configPath = path.resolve(__dirname, 'nextblockEL.txt');
const fs = require('fs');

var options = {
  method: 'POST',
  url: 'http://localhost:8080/newEventListenedNoHystory',
  headers: {
    'cache-control': 'no-cache',
    'Content-Type': 'application/json',
  },
  body: { more_info: 1, block_number: 1 },
  json: true,
};

let gate;
getGateway
  .then(async ({ gateway, network }) => {
    gate = gateway;
    const contract = network.getContract('fabcar');
    const network2 = await gateway.getNetwork('mychannel');

    const listener = await contract.addContractListener(
      'my-contract-listener-NUEVITO',
      'Movement',
      (err, event, blockNumber, transactionId, status) => {
        if (err) {
          console.error(err);
          return;
        }
        console.log(
          `Block Number: ${blockNumber} Transaction ID: ${transactionId} Status: ${status}`
        );
        event = event.payload.toString();
        console.log(event);
        console.log(
          '************************ Start Trade Event *******************************************************'
        );
        event = JSON.parse(event);
        // console.log(`type: ${event.type}`);
        options.body = event;
        request(options, function (error, response, body) {
          if (error) {
            throw new Error(error);
          }

          console.log(body);
        });
      }
    );
  })
  .catch((error) => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  })
  .finally(() => {
    setTimeout(() => {
      gate.disconnect();
    }, 3000000);
  });
