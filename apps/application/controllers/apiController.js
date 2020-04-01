'use strict';

const getGateway = require('../gateway/gateway');
const uuidv4 = require("uuid/v4");

module.exports.getTransaction = (req, res) => {
 // res.status(200);
 // res.status(200).json({msg: 'hi'});
return getGateway.then(async ({gateway, network})=>{
    const contract = network.getContract('fabcar');
    const result = await contract.submitTransaction('query', '3c10ede2-3a64-4610-962d-42f3bc50a25a');
    let response = JSON.parse(result.toString());
    res.status(200).json(response);
  });
};

module.exports.postTransaction = (req, res) => {
	console.log(req.body);
  return getGateway.then(async ({gateway, network})=>{
let bId = uuidv4()
 let id = uuidv4();
 let userId = uuidv4();
 let sourceCompanyId = uuidv4();
 let missionId = uuidv4();
let obj = {id: id, "type": "Add points", missionId, userId, sourceCompanyId, "sourceCompanyName": "Grin", "points": "150"}
    const contract = network.getContract('fabcar');
try{
    const result = await contract.submitTransaction('invoke', bId, JSON.stringify(obj));
   console.log(result);
  //  let response = JSON.parse(result.toString('utf-8'));
//console.log(response);
}catch(err){console.log(err)}

    res.status(200).json(obj);
  });
};

module.exports.createUser = (req, res) => {
// 	console.log(req.body);
//   return getGateway.then(async ({gateway, network})=>{
// let bId = uuidv4()
//  let id = uuidv4();
//  let userId = uuidv4();
//  let sourceCompanyId = uuidv4();
//  let missionId = uuidv4();
// let obj = {id: id, "type": "Add points", missionId, userId, sourceCompanyId, "sourceCompanyName": "Grin", "points": "150"}
//     const contract = network.getContract('fabcar');
// try{
//     const result = await contract.submitTransaction('invoke', bId, JSON.stringify(obj));
//    console.log(result);
//   //  let response = JSON.parse(result.toString('utf-8'));
// //console.log(response);
// }catch(err){console.log(err)}

     res.status(200).json("lokoo");
//   });
};
