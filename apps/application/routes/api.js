'use strict';

const express = require('express');
let router = express.Router();
const apiController = require('../controllers/apiController');

router.get('/v1/transaction/', apiController.getTransaction);
router.post('/v1/transaction/create', apiController.postTransaction);

router.post('/v1/userCreate', apiController.userCreate);
router.post('/v1/companyCreate', apiController.companyCreate);
router.post('/v1/missionCreate', apiController.missionCreate);
router.post('/v1/rewardCreate', apiController.rewardCreate);
router.post('/v1/missionEnroll', apiController.missionEnroll);
router.post('/v1/performMovement', apiController.performMovement);
// router.post('/v1/awardReward', apiController.awardReward);
router.post('/v1/redeemReward', apiController.redeemReward);

router.post('/v1/tokensSend', apiController.tokensSend);

module.exports = router;
