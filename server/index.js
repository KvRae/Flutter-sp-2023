const express = require('express');
const app = express();
const port = 9090;

const mongoose = require('mongoose');
const { updateDatabase } = require('./controllers');

mongoose.set('strictQuery', true);
mongoose.connect('mongodb://localhost:27017/examen_flutter_4sim')
    .then(() => console.log('Connected to MongoDB...'))
    .catch((err) => {
        console.error('Could not connect to MongoDB...')
        console.error(err)
    });

app.use(express.static('public'));

app.use(express.json());

app.use('/api/users', require('./routes/user.route'));
app.use('/api/currencies', require('./routes/currency.route'));


app.listen(port, () => {
    console.log(`Server is listening at http://localhost:${port}`)
    updateDatabase().then(() => {
        console.log("database updated");
    }).catch((err) => {
        console.log(err);
    })
});