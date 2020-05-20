'use strict';
const getGateway = require('./gateway/gateway');
// const util = require('util');
// const request = require('request');
// const path = require('path');
// const configPath = path.resolve(__dirname, 'nextblockEL.txt');
// const fs = require('fs');
const aws = require('aws-sdk');
//aws.config.loadFromPath(process.cwd() + "/aws-config.json");
aws.config.update({region: 'us-east-1', credentials: {accessKeyId: process.env.snsAKI,
  secretAccessKey: process.env.snsSAK}});
const sns = new aws.SNS();

// arn:aws:sns:us-west-1:156625418537:gamificatio-test


let options = {
  method: 'POST',
  url: 'http://localhost:8080/newEventListenedNoHystory',
  headers: {
    'cache-control': 'no-cache',
    'Content-Type': 'application/json',
  },
  body: { more_info: 1, block_number: 1 },
  json: true,
};

// let gate;
getGateway
  .then(async ({ gateway, network }) => {
    // gate = gateway;
    const contract = network.getContract('fabcar');
    // const network2 = await gateway.getNetwork('mychannel');

    contract.addContractListener(
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
        console.log(JSON.parse(event));
        console.log(
          '************************ Start Trade Event *******************************************************'
        );
        event = JSON.parse(event);
        // console.log(`type: ${event.type}`);
        options.body = event;
        // request(options, function (error, response, body) {
        //   if (error) {
        //     throw new Error(error);
        //   }

        //   console.log(body);
        // });
        // AWS logic
        let paramsPublish = {
          Message: `Hola ${event.userName}, has realizado un nuevo movimiento en gamificat.io. Llevas ${event.movementsPerformed} de ${event.movementsRequired}`,
          TopicArn: 'arn:aws:sns:us-east-1:156625418537:gamificatio-test'
        };
        sns.publish(paramsPublish, function(err, data) {
          if (err) {
            console.log(err);
          }
          else {
            console.log('::::::::> Valid ',data);
          }
        });
      }
    );
  })
  .catch((error) => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  })
  .finally(() => {
    // setTimeout(() => {
    //   gate.disconnect();
    // }, 3000000);
  });
