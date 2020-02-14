'use strict';

const getGateway = require('./gateway/gateway');

let gate;
getGateway.then(async({gateway, network}) => {
  gate = gateway;
  const contract = network.getContract('fabcar');
  await contract.submitTransaction('invoke', '1', '3', '1');

  console.log('Transaction has been submitted');
  return;
})
  .catch(error => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  })
  .finally(()=>{
    gate.disconnect();
  });
