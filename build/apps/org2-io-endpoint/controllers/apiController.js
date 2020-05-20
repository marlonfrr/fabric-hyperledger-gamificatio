'use strict';

// module.exports.get = (req, res) => {
//   return getGateway.then(async ({gateway, network})=>{
//     try{
//       const contract = network.getContract('chaincode');
//       const result = await contract.evaluateTransaction('query', req.params.id);
//       let response = parseInt(result.toString(),10);
//       if(isNaN(response)){
//         return res.status(404).json(null);
//       }
//       return res.status(200).json(response);
//     }
//     catch(err){
//       throw err;
//     }
//   }).catch(err => {
//     res.status(500).json(err);
//   });
// };

module.exports.post = (req, res) => {
  console.log(req.body);
  return res.json({msg: 'ok'});
};
