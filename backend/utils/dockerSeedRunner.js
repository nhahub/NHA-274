import dotenv from 'dotenv';
import importIfNeeded from './seedIfNeeded.js';
import connectDB from '../config/db.js';

dotenv.config();

const run = async () => {
  try {
    await connectDB();
    await importIfNeeded(false);
    console.log('Docker seed runner finished');
    process.exit(0);
  } catch (err) {
    console.error('Docker seed runner error', err);
    process.exit(1);
  }
};

run();
