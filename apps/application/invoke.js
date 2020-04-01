
const getGateway = require('./gateway/gateway');
const uuidv4 = require("uuid/v4");

let gate;
getGateway.then(async({gateway, network}) => {
 let bId = uuidv4()
 let id = uuidv4();
 let userId = uuidv4();
 let sourceCompanyId = uuidv4();
 let missionId = uuidv4();
 let obj = {id: id, "type": "Add points", missionId, userId, sourceCompanyId, "sourceCompanyName": "Grin", "points": "150"}
  gate = gateway;
  const contract = network.getContract('fabcar');
  await contract.submitTransaction('invoke', bId, JSON.stringify(obj));

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

