'use strict';

const getGateway = require('../gateway/gateway');

module.exports.get = (req, res) => {
  res.status(200);
  res.status(200).json({msg: 'hi'});
};

module.exports.post = (req, res) => {
  return getGateway.then(async ({gateway, network})=>{
    const contract = network.getContract('fabcar');
    const result = await contract.submitTransaction('invoke', '1', '2', '3');

    // let response = JSON.parse(result.toString());

    res.status(200).json({invoked: 'ok'});
  });
};
