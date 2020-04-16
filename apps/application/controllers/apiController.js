"use strict";

const getGateway = require("../gateway/gateway");
const uuidv4 = require("uuid/v4");

module.exports.auth = (req, res) => {
  // return getGateway.then(async ({ gateway, network }) => {
  //   const contract = network.getContract("fabcar");
  //   const result = await contract.submitTransaction(
  //     "query",
  //     req.body.transactionId
  //   );
  //   let response = JSON.parse(result.toString());
  res.status(200).json({ names: "Raver" });
  // });
};

module.exports.getTransaction = (req, res) => {
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    console.log(req.body);
    const result = await contract.submitTransaction("query", req.body.key);
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
      points: "150",
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
      receivedTransactions: [],
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
    // let key = uuidv4();
    let key = name;
    let obj = {
      name,
      missions: [],
      guestMissions: [],
      rewards: [],
      companyId: key,
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

    res.status(200).json(obj);
  });
};

module.exports.missionCreate = (req, res) => {
  console.log(req.body);
  let {
    companyId,
    missionName,
    tokensLimit,
    type,
    movementsRequired,
    key1,
    key2,
    description,
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
        reward: {
          rewardId: uuidv4(),
          description,
          key1,
          key2
        },
        tokensLimit,
        movementsRequired,
        type,
        date: new Date().getTime(),
        missionId: key
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
        date: new Date().getTime(),
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
    let obj = {
      companyId,
    };
    console.log("obj::::>", obj);
    const result = await contract.submitTransaction(
      "getMissions",
      JSON.stringify(obj)
    );
    let retu = JSON.parse(result.toString());
    console.log("result in controller:::>", result);
    console.log("result in controller toString:::>", retu);
    res.status(200).json(retu);
    // let response = {
    //   missions: [
    //     {
    //       _id: "36503733-acb7-473b-b75a-90b8cfa353b6",
    //       _rev: "1-02bd2bea0cafc3229b772a572d318966",
    //       companyId: "c8ef0428-8507-477a-a67a-3aa1f07a4b79",
    //       date:
    //         "Thu Apr 02 2020 17:38:53 GMT+0000 (Coordinated Universal Time)",
    //       guestCompanyId: "a38f6556-bbdf-486f-ad13-6f526af8a3d4",
    //       missionName: "Test3cross",
    //       movementsRequired: 20,
    //       rewardId: "954942d8-19ed-4b24-b208-37cf9a80c2fa",
    //       tokensLimit: 1000,
    //       from: "muvo.png",
    //       to: "raver.png",
    //       reward: {
    //         desc: "Completa 5 viajes en Muvo y obtén 20% de descuento en Raver",
    //         key1: "Cupón",
    //         key2: "20%",
    //       },
    //       type: "cross",
    //       "~version": "CgMBCgA=",
    //     },
    //     {
    //       _id: "36503733-acb7-473b-b75a-90b8cfa353b6",
    //       _rev: "1-02bd2bea0cafc3229b772a572d318966",
    //       companyId: "c8ef0428-8507-477a-a67a-3aa1f07a4b79",
    //       date:
    //         "Thu Apr 02 2020 17:38:53 GMT+0000 (Coordinated Universal Time)",
    //       guestCompanyId: "a38f6556-bbdf-486f-ad13-6f526af8a3d4",
    //       missionName: "Test5cross",
    //       movementsRequired: 20,
    //       from: "grin.png",
    //       to: "raver.png",
    //       reward: {
    //         desc:
    //           "Completa 4 viajes en Grin y obtén 1 entrada a un concierto en Raver",
    //         key1: "Entrada gratis",
    //         key2: "Concierto X",
    //       },
    //       rewardId: "954942d8-19ed-4b24-b208-37cf9a80c2fa",
    //       tokensLimit: 1000,
    //       type: "cross",
    //       "~version": "CgMBCgA=",
    //     },
    //     {
    //       _id: "36503733-acb7-473b-b75a-90b8cfa353b6",
    //       _rev: "1-02bd2bea0cafc3229b772a572d318966",
    //       companyId: "c8ef0428-8507-477a-a67a-3aa1f07a4b79",
    //       date:
    //         "Thu Apr 02 2020 17:38:53 GMT+0000 (Coordinated Universal Time)",
    //       guestCompanyId: "a38f6556-bbdf-486f-ad13-6f526af8a3d4",
    //       missionName: "EnlaU",
    //       movementsRequired: 20,
    //       from: "raver.png",
    //       to: "enlau.png",
    //       reward: {
    //         desc: "Compra 1 entrada y obtén domicilio gratis hasta 5.000",
    //         key1: "Domicilio gratis",
    //         key2: "5.0000",
    //       },
    //       rewardId: "954942d8-19ed-4b24-b208-37cf9a80c2fa",
    //       tokensLimit: 1000,
    //       type: "cross",
    //       "~version": "CgMBCgA=",
    //     },
    //     {
    //       _id: "36503733-acb7-473b-b75a-90b8cfa353b6",
    //       _rev: "1-02bd2bea0cafc3229b772a572d318966",
    //       companyId: "c8ef0428-8507-477a-a67a-3aa1f07a4b79",
    //       date:
    //         "Thu Apr 02 2020 17:38:53 GMT+0000 (Coordinated Universal Time)",
    //       guestCompanyId: "a38f6556-bbdf-486f-ad13-6f526af8a3d4",
    //       missionName: "Beat",
    //       movementsRequired: 20,
    //       from: "raver.png",
    //       to: "beat.png",
    //       reward: {
    //         desc: "Compra 1 entrada y recibe un viaje gratis en Beat",
    //         key1: "Viaje gratis",
    //         key2: "10.000",
    //       },
    //       rewardId: "954942d8-19ed-4b24-b208-37cf9a80c2fa",
    //       tokensLimit: 1000,
    //       type: "cross",
    //       "~version": "CgMBCgA=",
    //     },
    //   ],
    // };
  });
};
// module.exports.getRewards = (req, res) => {
//   return getGateway.then(async ({ gateway, network }) => {
//     const contract = network.getContract("fabcar");
//     let { companyId } = req.body;
//     let obj = {
//       companyId,
//     };
//     console.log("obj::::>", obj);
//     const result = await contract.submitTransaction(
//       "getRewards",
//       JSON.stringify(obj)
//     );
//     let retu = JSON.parse(result.toString());
//     res.status(200).json(retu);
//   });
// };

module.exports.rewardCreate = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = {
      companyId: req.body.companyId,
      type: "reward",
      desc: "Test description",
      key1: "coupon",
      key2: "20%",
      rewardId: key,
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

    res.status(200).json(obj);
  });
};

module.exports.missionEnroll = (req, res) => {
  console.log(req.body);
  return getGateway.then(async ({ gateway, network }) => {
    const contract = network.getContract("fabcar");
    let key = uuidv4();
    let obj = {
      userId: req.body.userId,
      missionId: req.body.missionId,
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
      missionId: req.body.missionId,
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
