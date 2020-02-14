'use strict';

const express = require('express');
let router = express.Router();
const apiController = require('../controllers/apiController');

router.get('/', apiController.get);
router.post('/', apiController.post);

module.exports = router;
