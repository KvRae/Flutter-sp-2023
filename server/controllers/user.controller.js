const { User } = require('../models/user.model');

module.exports = {
    createUsers: async () => {
        const users = await User.find();
        if (users.length > 0) {
            return true;
        }

        const user1 = new User({ username: 'wiem', identifier: '1458', balance: 7410 });
        const user2 = new User({ username: 'john', identifier: '2682', balance: 200 });
        const user3 = new User({ username: 'maria', identifier: '4205', balance: 0 });
        const user4 = new User({ username: 'july', identifier: '3602', balance: 198520 });

        await user1.save();
        await user2.save();
        await user3.save();
        await user4.save();
        return true;
    },
    onAuthorize: async (req, res) => {
        const { username, identifier } = req.body;
        const user = await User.findOne({
            username,
            identifier
        });
        if (user) {
            user.__v = undefined;
            user.currencies = undefined;
            console.log("user found");
            return res.status(200).json(user);
        }
        console.log("user not found");
        res.status(401).json({ message: 'Username or ID are incorrect' });
    }

}