'use strict';

const express = require('express');
let router = express.Router();
const apiRouter = require('./api');
const swaggerUi = require('swagger-ui-express');
const yaml = require('js-yaml');
const fs = require('fs');
const swaggerDocument = yaml.safeLoad(fs.readFileSync('./swagger.yaml'));

router.use('/v1/api', apiRouter);
router.post('/v1/transaction/create', apiRouter)
router.use('/api-docs', swaggerUi.serve);
router.get('/api-docs', swaggerUi.setup(swaggerDocument));
router.post('/v1/key/', apiRouter);

// Simple login
router.post('/v1/auth', apiRouter)

router.post('/v1/getMissions', apiRouter);
// router.post('/v1/getRewards', apiRouter);

router.post('/v1/userCreate', apiRouter);
router.post('/v1/companyCreate', apiRouter);
router.post('/v1/missionCreate', apiRouter);
router.post('/v1/multipleCrossMissionCreate', apiRouter);
router.post('/v1/rewardCreate', apiRouter);
router.post('/v1/missionEnroll', apiRouter);
router.post('/v1/performMovement', apiRouter);
// router.post('/v1/awardReward', apiRouter);
router.post('/v1/redeemReward', apiRouter);

router.post('/v1/tokensSend', apiRouter);

module.exports = router;
