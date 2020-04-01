'use strict';

const express = require('express');
let router = express.Router();
const apiController = require('../controllers/apiController');

router.get('/', apiController.get);
router.post('/v1/transaction/create', apiController.post);

module.exports = router;
