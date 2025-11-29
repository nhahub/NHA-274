import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Link, useNavigate } from 'react-router-dom';
import { Trash2, ShoppingBag, ArrowRight } from 'lucide-react';
import { addToCart, removeFromCart } from '../slices/cartSlice';
import Message from '../components/Message';

const CartScreen = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const cart = useSelector((state) => state.cart);
  const { cartItems } = cart;

  const addToCartHandler = (product, qty) => {
    dispatch(addToCart({ ...product, qty }));
  };

  const removeFromCartHandler = (id) => {
    dispatch(removeFromCart(id));
  };

  const checkoutHandler = () => {
    navigate('/login?redirect=/shipping');
  };

  return (
    <div className="max-w-7xl mx-auto">
      <h1 className="text-3xl font-bold mb-8 text-black-900 dark:text-black">
        Shopping Cart
      </h1>

      {cartItems.length === 0 ? (
        <div className="text-center py-12">
          <ShoppingBag className="w-24 h-24 mx-auto text-black-300 dark:text-black-600 mb-4" />
          <Message variant="info">
            Your cart is empty.{' '}
            <Link to="/" className="font-semibold underline">
              Go Shopping
            </Link>
          </Message>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Cart Items */}
          <div className="lg:col-span-2 space-y-4">
            {cartItems.map((item) => (
              <div
                key={item._id}
                className="bg-white dark:bg-gray-800 rounded-lg shadow p-4 flex flex-col sm:flex-row items-center gap-4"
              >
                <img
                  src={item.image}
                  alt={item.name}
                  className="w-24 h-24 object-cover rounded-lg"
                />

                <div className="flex-1 text-center sm:text-left">
                  <Link
                    to={`/product/${item._id}`}
                    className="text-lg font-semibold text-black-900 dark:text-black hover:text-indigo-600 dark:hover:text-indigo-400"
                  >
                    {item.name}
                  </Link>
                  <p className="text-xl font-bold text-indigo-600 dark:text-indigo-400 mt-1">
                    ${item.price}
                  </p>
                </div>

                <div className="flex items-center gap-4">
                  <select
                    value={item.qty}
                    onChange={(e) =>
                      addToCartHandler(item, Number(e.target.value))
                    }
                    className="px-3 py-2 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-black-900 dark:text-black focus:ring-2 focus:ring-indigo-500"
                  >
                    {[...Array(item.countInStock).keys()].map((x) => (
                      <option key={x + 1} value={x + 1}>
                        {x + 1}
                      </option>
                    ))}
                  </select>

                  <button
                    onClick={() => removeFromCartHandler(item._id)}
                    className="p-2 text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition"
                  >
                    <Trash2 className="w-5 h-5" />
                  </button>
                </div>
              </div>
            ))}
          </div>

          {/* Order Summary */}
          <div className="lg:col-span-1">
            <div className="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 sticky top-24">
              <h2 className="text-2xl font-bold mb-6 text-black-900 dark:text-black">
                Order Summary
              </h2>

              <div className="space-y-4 mb-6">
                <div className="flex justify-between text-black-600 dark:text-black-400">
                  <span>Items ({cartItems.reduce((acc, item) => acc + item.qty, 0)})</span>
                </div>

                <div className="border-t border-gray-200 dark:border-gray-700 pt-4">
                  <div className="flex justify-between items-center">
                    <span className="text-lg font-semibold text-black-900 dark:text-black">
                      Subtotal
                    </span>
                    <span className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
                      $
                      {cartItems
                        .reduce((acc, item) => acc + item.qty * item.price, 0)
                        .toFixed(2)}
                    </span>
                  </div>
                </div>
              </div>

              <button
                onClick={checkoutHandler}
                disabled={cartItems.length === 0}
                className="w-full py-3 px-6 bg-indigo-600 hover:bg-indigo-700 disabled:bg-gray-400 text-white font-semibold rounded-lg transition active:scale-95 flex items-center justify-center gap-2"
              >
                Proceed to Checkout
                <ArrowRight className="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default CartScreen;
