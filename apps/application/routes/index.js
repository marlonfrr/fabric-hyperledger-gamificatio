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
router.get('/v1/transaction/', apiRouter);
module.exports = router;
