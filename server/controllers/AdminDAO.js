require('../utils/MongooseUtils.js');
const Users = require('../models/User.js');

const AdminDAO = {
    async selectByEmail(email) {
        const query = { email: email, isAdmin: true };
        const admin = await Users.findOne(query).exec();
        return admin;
    },
    async updatePassByEmail(email, newHashedPassword) {
        const filter = { email: email};
        const update = { password: newHashedPassword };
        const option = { new: true, runValidators: true }
        const adminUpdate = await Users.findOneAndUpdate(filter, update, option);
        return adminUpdate;
    }
};

module.exports = AdminDAO;