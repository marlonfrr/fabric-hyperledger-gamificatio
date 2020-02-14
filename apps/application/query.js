'use strict';

const getGateway = require('./gateway/gateway');

let gate;
getGateway.then(async({gateway, network}) => {
  gate = gateway;
  const contract = network.getContract('fabcar');
  const result = await contract.evaluateTransaction('query', '3');

  let response = JSON.parse(result.toString());
  console.log(response);
  return;
})
  .catch(error => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  })
  .finally(()=>{
    gate.disconnect();
  });
