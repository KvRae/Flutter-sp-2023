const { Currency } = require('../models/currency.model');
const { User } = require('../models/user.model');

module.exports = {
    createCurrencies: async () => {
        const currencies = await Currency.find();
        if (currencies.length > 0) {
            return true;
        }

        let btcDescription = "Bitcoin is a cryptocurrency invented in 2008 by an unknown person or group of people using the name Satoshi Nakamoto and started in 2009 when its implementation was released as open-source"
        const btc = new Currency({ name: 'Bitcoin', unitPrice: 16775.2, code: "BTC", quantity: 1, description: btcDescription, image : "BTC.png" });
        let binanceDescription = "Binance Coin (BNB) is a cryptocurrency token and operates on the Ethereum platform. Binance Coin has a current supply of 200,000,000 with 190,000,000 in circulation. The last known price of Binance Coin is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.binance.com/."
        const binance = new Currency({ name: 'Binance Coin', unitPrice: 243.0, code: "BNB", quantity: 1, description: binanceDescription, image : "BNB.png" });
        let cardanoDescription = "Cardano (ADA) is a cryptocurrency token and operates on the Ethereum platform. Cardano has a current supply of 45,000,000,000 with 25,927,070,538 in circulation. The last known price of Cardano is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.cardano.org/."
        const cardano = new Currency({ name: 'Cardano', unitPrice: 0.25, code: "ADA", quantity: 1, description: cardanoDescription, image : "ADA.png" });
        let DodgeCoinDescription = "DodgeCoin (DOGE) is a cryptocurrency token and operates on the Ethereum platform. DodgeCoin has a current supply of 45,000,000,000 with 25,927,070,538 in circulation. The last known price of DodgeCoin is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.cardano.org/."
        const dodgeCoin = new Currency({ name: 'Dodge Coin', unitPrice: 0.076, code: "DOGE", quantity: 1, description: DodgeCoinDescription, image : "DODGE.png" });
        let polkadotDescription = "Polkadot (DOT) is a cryptocurrency token and operates on the Ethereum platform. Polkadot has a current supply of 45,000,000,000 with 25,927,070,538 in circulation. The last known price of Polkadot is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.cardano.org/."
        const polkadot = new Currency({ name: 'Polkadot', unitPrice: 4.46, code: "DOT", quantity: 1, description: polkadotDescription, image : "DOT.png" });
        let terraDescription = "Terra (LUNA) is a cryptocurrency token and operates on the Ethereum platform. Terra has a current supply of 45,000,000,000 with 25,927,070,538 in circulation. The last known price of Terra is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.cardano.org/."
        const terra = new Currency({ name: 'Terra', unitPrice: 0.000270, code: "LUNA", quantity: 1, description: terraDescription, image : "LUNA.png" });
        let solanaDescription = "Solana (SOL) is a cryptocurrency token and operates on the Ethereum platform. Solana has a current supply of 45,000,000,000 with 25,927,070,538 in circulation. The last known price of Solana is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.cardano.org/."
        const solana = new Currency({ name: 'Solana', unitPrice: 11.28, code: "SOL", quantity: 1, description: solanaDescription, image : "SOL.png" });
        let usdtDescription = "Tether (USDT) is a token and operates on the Ethereum platform. Tether has a current supply of 45,000,000,000 with 25,927,070,538 in circulation. The last known price of Tether is 0.00000000 USD and is down -100.00 over the last 24 hours. It is currently trading on 1 active market(s) with 0.00 traded over the last 24 hours. More information can be found at https://www.cardano.org/."
        const usdt = new Currency({ name: 'Tether', unitPrice: 1.0, code: "USDT", quantity: 1, description: usdtDescription, image : "USDT.png"   });

        await btc.save();
        await binance.save();
        await cardano.save();
        await dodgeCoin.save();
        await polkadot.save();
        await terra.save();
        await solana.save();
        await usdt.save();

        return true;
    },
    getAllCurrencies : async (req, res) => {
        const currencies = await Currency.find().select('-__v');
        console.log(currencies);
        res.json(currencies);
    },
    buyCurrency: async (req, res) => {
        console.log(req.body);
        const { currencyId, quantity } = req.body;
        const currency = await Currency.findById(currencyId);
        //console.log(currency);
        const user = await User.findById(req.params.id_user);
        //console.log(user);
        if (user.balance < currency.unitPrice * quantity) {
            return res.status(403).json({ message: "No available funds" });
        }
        user.balance -= currency.unitPrice * quantity;
        if(!user.currencies){
            user.currencies = [];
        }
        if(user.currencies.find(c => c.currency == currencyId)){
            user.currencies.find(c => c.currency == currencyId).quantity += quantity;
        }else{
            user.currencies.push({ currency: currencyId, quantity });
        }
        await user.save();

        res.status(200).json({ message: "Success" });
    },
    getMyCurrencies: async (req, res) => {
        const user = await User.findById(req.params.id_user).populate("currencies.currency", '-__v').select('-__v');
        res.json(user.currencies);
    }
}
updatescore: async (req, res) => {
    const { questionId, userId,reponse } = req.body;
    const question = await Question.findById(questionId);
    const user = await User.findById(userId);
    let score =  user.score ?? 0;

    if (reponse == "yes") {
        score+=question.choix1;
    }
    else if (reponse == "no") {
        score+=question.choix2;
    }
    else if (reponse == "maybe") {
        score+=question.choix3;
    }
    User.findByIdAndUpdate(userId, { score: score }, { new: true }).then((user) => {

    res.status(200).json({ message: "Success" });})
    
}