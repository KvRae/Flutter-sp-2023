const { Schema, model } = require('mongoose');

const currencySchema = new Schema({
    image: String,
    name: String,
    unitPrice: Number,
    code: String,
    description: String
});

const Currency = model("currency", currencySchema);

module.exports = { Currency };