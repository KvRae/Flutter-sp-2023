const { onAuthorize } = require('../controllers/user.controller');

const router = require('express').Router();

router.route('/login/id')
    .post(onAuthorize)


module.exports = router;