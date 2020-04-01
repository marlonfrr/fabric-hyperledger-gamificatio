'use strict';

const express = require('express');
let router = express.Router();
const apiController = require('../controllers/apiController');

router.get('/v1/transaction/', apiController.getTransaction);
router.post('/v1/transaction/create', apiController.postTransaction);
router.post('/v1/transaction/createUser', apiController.createUser);

module.exports = router;
