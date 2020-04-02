"use strict";

const getGateway = require("../gateway/gateway");
const uuidv4 = require("uuid/v4");

module.exports.getTransaction = (req, res) => {
  // res.status(200);
  // res.status(200).json({msg: 'hi'});
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    const result = await contract.submitTransaction(
      "query",
      "3c10ede2-3a64-4610-962d-42f3bc50a25a"
    );
    let response = JSON.parse(result.toString());
    res.status(200).json(response);
  });
};

module.exports.postTransaction = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    let bId = uuidv4();
    let id = uuidv4();
    let userId = uuidv4();
    let sourceCompanyId = uuidv4();
    let missionId = uuidv4();
    let obj = {
      id: id,
      type: "Add points",
      missionId,
      userId,
      sourceCompanyId,
      sourceCompanyName: "Grin",
      points: "150"
    };
    const contract = network.getContract("fabcar");
    try {
      const result = await contract.submitTransaction(
        "invoke",
        bId,
        JSON.stringify(obj)
      );
      console.log(result);
      //  let response = JSON.parse(result.toString('utf-8'));
      //console.log(response);
    } catch (err) {
      console.log(err);
    }

    res.status(200).json(obj);
  });
};

module.exports.userCreate = (req, res) => {
  console.log(req.body);
  let { name, id, age } = req.body;
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    // let key = uuidv4();
    let obj = {
      name,
      id,
      age,
      tokens: 0,
      enrolledMissions: [],
      availableRewards: [],
      sendTransactions: [],
      receivedTransactions: []
    };
    try {
      const result = await contract.submitTransaction(
        "userCreate",
        id,
        JSON.stringify(obj)
      );
      console.log(result);
    } catch (err) {
      console.log(err);
    }

    res.status(200).json(obj);
  });
};

module.exports.companyCreate = (req, res) => {
  console.log(req.body);
  let { name } = req.body;
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = {
      name,
      missions: [],
      guestMissions: []
    };
    try {
      const result = await contract.submitTransaction(
        "companyCreate",
        key,
        JSON.stringify(obj)
      );
      console.log(result);
    } catch (err) {
      console.log(err);
    }

    res.status(200).json({ ...obj, key });
  });
};

module.exports.missionCreate = (req, res) => {
  console.log(req.body);
  let {
    companyId,
    missionName,
    tokensLimit,
    rewardId,
    type,
    movementsRequired
  } = req.body;
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = undefined;
    if (type == "cross") {
      console.log("-----------------------------------------");
      console.log("cross");
      console.log("-----------------------------------------");
      obj = {
        companyId,
        guestCompanyId: req.body.guestCompanyId,
        missionName,
        rewardId,
        tokensLimit,
        movementsRequired,
        type,
        date: Date(Date.now())
      };
    } else if (type == "self") {
      console.log("-----------------------------------------");
      console.log("self");
      console.log("-----------------------------------------");
      obj = {
        companyId,
        missionName,
        rewardId,
        tokensLimit,
        type,
        date: Date(Date.now())
      };
    } else {
      console.log("-----------------------------------------");
      console.log("Ningún tipo (apiController.js)");
      console.log("-----------------------------------------");
      res.status(500).json({ status: "error" });
    }
    try {
      const result = await contract.submitTransaction(
        "missionCreate",
        key,
        JSON.stringify(obj)
      );
      console.log(result);
    } catch (err) {
      console.log("Failed submiting transaction to contract", err);
    }

    res.status(200).json({ ...obj, key });
  });
};

module.exports.getMissions = (req, res) => {
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let { companyId } = req.body;
    const result = await contract.submitTransaction(
      "getMissions",
      JSON.stringify({ companyId })
    );
    let response = JSON.parse(result.toString());
    res.status(200).json(response);
  });
};

module.exports.rewardCreate = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = {
      companyId: req.body.companyId,
      type: "reward",
      key1: "coupon",
      key2: "20%"
    };
    try {
      const result = await contract.submitTransaction(
        "rewardCreate",
        key,
        JSON.stringify(obj)
      );
      console.log(result);
    } catch (err) {
      console.log(err);
    }

    res.status(200).json({ ...obj, key });
  });
};

module.exports.missionEnroll = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = {
      userId: req.body.userId,
      missionId: req.body.missionId
    };
    try {
      const result = await contract.submitTransaction(
        "missionEnroll",
        key,
        JSON.stringify(obj)
      );
      console.log(result);
    } catch (err) {
      console.log(err);
    }

    res.status(200).json(obj);
  });
};

module.exports.performMovement = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = {
      userId: req.body.userId,
      missionId: req.body.missionId
    };
    try {
      const result = await contract.submitTransaction(
        "performMovement",
        key,
        JSON.stringify(obj)
      );
      console.log(result);
    } catch (err) {
      console.log(err);
    }

    res.status(200).json(obj);
  });
};

// module.exports.awardReward = (req, res) => {
//   console.log(req.body);
//   return getGateway.then(async ({ gateway, network }) => {
//     const contract = network.getContract("fabcar");
//     // try{
//     //     const result = await contract.submitTransaction('invoke', bId, JSON.stringify(obj));
//     //    console.log(result);
//     //   //  let response = JSON.parse(result.toString('utf-8'));
//     // //console.log(response);
//     // }catch(err){console.log(err)}

//     res.status(200).json("awardReward");
//   });
// };

module.exports.redeemReward = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    // try{
    //     const result = await contract.submitTransaction('invoke', bId, JSON.stringify(obj));
    //    console.log(result);
    //   //  let response = JSON.parse(result.toString('utf-8'));
    // //console.log(response);
    // }catch(err){console.log(err)}

    res.status(200).json("redeemReward");
  });
};

module.exports.tokensSend = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    // try{
    //     const result = await contract.submitTransaction('invoke', bId, JSON.stringify(obj));
    //    console.log(result);
    //   //  let response = JSON.parse(result.toString('utf-8'));
    // //console.log(response);
    // }catch(err){console.log(err)}

    res.status(200).json("tokensSend");
  });
};
