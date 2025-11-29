import users from '../data/users.js';
import products from '../data/products.js';
import User from '../models/userModel.js';
import Product from '../models/productModel.js';
import Order from '../models/orderModel.js';

const importIfNeeded = async (force = false) => {
  try {
    const count = await Product.countDocuments();
    if (!force && count > 0) {
      console.log('Database already contains products — skipping seed');
      return;
    }

    console.log('Seeding database with sample data...');

    await Order.deleteMany();
    await Product.deleteMany();
    await User.deleteMany();

    const createdUsers = await User.insertMany(users);
    const adminUser = createdUsers[0]._id;

    const sampleProducts = products.map((product) => {
      return { ...product, user: adminUser };
    });

    await Product.insertMany(sampleProducts);

    console.log('Data seeded');
  } catch (error) {
    console.error('Seeding error:', error.message || error);
  }
};

export default importIfNeeded;
