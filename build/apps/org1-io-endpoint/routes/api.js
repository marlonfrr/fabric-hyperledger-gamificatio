'use strict';

const express = require('express');
let router = express.Router();
const apiController = require('../controllers/apiController');

// router.get('/event', apiController.get);
router.post('/event', apiController.post);

module.exports = router;
