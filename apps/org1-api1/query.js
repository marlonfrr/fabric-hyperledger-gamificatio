'use strict';

const getGateway = require('./gateway/gateway');

let gate;
getGateway.then(async({gateway, network}) => {
  gate = gateway;
  const contract = network.getContract('chaincode');
  const result = await contract.submitTransaction('query', '3c10ede2-3a64-4610-962d-42f3bc50a25a');
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
