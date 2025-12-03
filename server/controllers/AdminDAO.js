require('../utils/MongooseUtils.js');
const Users = require('../models/User.js');

const AdminDAO = {
    //select
    async selectByEmail(email) {
        const query = { email: email, isAdmin: true };
        const admin = await Users.findOne(query).exec();
        return admin;
    },
    async selectById(_id) {
        const query = { _id: _id};
        const admin = await Users.findById(query).exec();
        return admin;
    },

    //update
    async updatePictureById(_id, image) {
        const filter = { _id: _id };
        const update = { image: image};
        const option = { new: true, runValidators: true };
        const adminUpdate = await Users.findByIdAndUpdate(filter, update, option);
        return adminUpdate;
    },
    async updatePassByEmail(email, newHashedPassword) {
        const filter = { email: email};
        const update = { password: newHashedPassword };
        const option = { new: true, runValidators: true };
        const adminUpdate = await Users.findOneAndUpdate(filter, update, option);
        return adminUpdate;
    },
    async updateProfileById(user) {
        const filter = { _id: user._id};
        const update = {
            username: user.username,
            email: user.email,
            phone: user.phone,
        }
        const option = { new: true, runValidators: true }
        const admin = await Users.findByIdAndUpdate(filter, update, option).exec();
        return admin;
    },
};

module.exports = AdminDAO;