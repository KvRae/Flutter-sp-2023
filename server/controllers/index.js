const { createCurrencies } = require("./currency.controller");
const { createUsers } = require("./user.controller");

module.exports = {
    updateDatabase: async () => {
        await createUsers();
        await createCurrencies();
    }
}