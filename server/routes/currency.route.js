const { getAllCurrencies, getMyCurrencies, buyCurrency } = require('../controllers/currency.controller');

const router = require('express').Router();

router.get("/", getAllCurrencies)
router.get("/liste/:id_user", getMyCurrencies)
router.post("/:id_user", buyCurrency)


module.exports = router;