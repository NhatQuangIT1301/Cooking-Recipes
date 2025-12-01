require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors({
    origin: 'http://localhost:4000',
    credentials: true,
}));

app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`);
});
const bodyParser = require('body-parser');
app.use(bodyParser.json({limit: '10mb'}));
app.use(bodyParser.urlencoded({extended: true, limit: '10mb'}));


const User = require('./models/User.js');
const Bcrypt = require('./utils/BcryptUtils.js');

const createDeafaultAdmin = async () => {
    try {
        const existingAdmin = await User.findOne({ isAdmin: true});

        if (!existingAdmin) {
            const hashedPassword = await Bcrypt.hash('AdminCookingRecipes@2526');
            const newAdmin = new User({
                username: 'Admin',
                email: 'cookingrecipes2526@gmail.com',
                phone: '0914921033',
                password: hashedPassword,
                isVerified: true,
                isAdmin: true,
            });

            await newAdmin.save();
            console.log('Create successed!');
        } else {
            console.log('Already created!');
        }
    } catch (e) {
        console.error('There are something wrong!', e);
    }
};

createDeafaultAdmin();

app.use('/api/admin', require('./api/admin.js'));