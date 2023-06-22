const { Schema, model } = require('mongoose');

const userSchema = new Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        trim: true,
        minlength: 3
    },
    identifier: {
        type: String,
        required: true,
        trim: true,
        minlength: 3
    },
    balance: {
        type: Number,
        default: 100000
    },
    currencies: [{
        currency: {
            type: Schema.Types.ObjectId,
            ref: 'currency'
        },
        quantity: {
            type: Number,
            default: 0
        }
    }]
});

const User = model("user", userSchema);

module.exports = { User };