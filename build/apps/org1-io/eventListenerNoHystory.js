'use strict';
const getGateway = require('./gateway/gateway');
const request = require('request');

let options = {
  method: 'POST',
  url: process.env.IO_ENDPOINT,
  headers: {
    'cache-control': 'no-cache',
    'Content-Type': 'application/json',
  },
  body: {},
  json: true,
};

let gate;
getGateway
  .then(async ({ gateway, network }) => {
    gate = gateway;
    const contract = network.getContract('chaincode');

    await contract.addContractListener(
      'my-contract-listener-NUEVITO',
      process.env.EVENT,
      (err, event, blockNumber, transactionId, status) => {
        if (err) {
          console.error(err);
          return;
        }
        console.log(
          `Block Number: ${blockNumber} Transaction ID: ${transactionId} Status: ${status}`
        );
        event = event.payload.toString();
        event = JSON.parse(event);
        options.body.event = event;
        options.body.blockNumber = blockNumber;
        options.body.transactionId = transactionId;
        options.body.status = status;

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
    // gate.disconnect();
  });
