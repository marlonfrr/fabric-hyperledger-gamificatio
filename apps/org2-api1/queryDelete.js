'use strict';

const getGateway = require('./gateway/gateway');

let gate;
getGateway.then(async({gateway, network}) => {
  gate = gateway;
  const contract = network.getContract('chaincode');
  const result = await contract.submitTransaction('delete', 'Hi');
//  let response = result;
  let response = result.toString();
// let response = JSON.parse(result.toString());
  console.log("Response>>>", response);
  return;
})
  .catch(error => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  })
  .finally(()=>{
    gate.disconnect();
  });
