const getGateway = require("./gateway/gateway");
const uuidv4 = require("uuid/v4");

let gate;
getGateway
  .then(async ({ gateway, network }) => {
    let key = uuidv4();
    let name = "Marlon Forero";
    let obj = {
      name,
      tokens: 0,
      enrolledMissions: [],
      availableRewards: [],
      sendTransactions: [],
      receivedTransactions: []
    };
    gate = gateway;
    const contract = network.getContract("fabcar");
    await contract.submitTransaction("createUser", key, JSON.stringify(obj));
    console.log("Transaction has been submitted");
    return;
  })
  .catch(error => {
    console.log(`Error processing transaction. ${error}`);
    console.log(error.stack);
  })
  .finally(() => {
    gate.disconnect();
  });
