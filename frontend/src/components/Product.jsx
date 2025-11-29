import { Link, useNavigate } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import { ShoppingCart } from 'lucide-react';
import Rating from './Rating';
import { addToCart } from '../slices/cartSlice';

const Product = ({ product }) => {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const addToCartHandler = (e) => {
    e.preventDefault();
    e.stopPropagation();
    dispatch(addToCart({ ...product, qty: 1 }));
    navigate('/cart');
  };

  const inStock = product.countInStock > 0;
  const lowStock = product.countInStock > 0 && product.countInStock <= 5;

  return (
    <div className='group card-interactive animate-fade-in-up relative'>
      {/* Stock Badge */}
      <div className='absolute top-3 right-3 z-10'>
        {!inStock ? (
          <span className='badge-danger'>Out of Stock</span>
        ) : lowStock ? (
          <span className='badge-warning'>Only {product.countInStock} left</span>
        ) : null}
      </div>

      {/* Image with Zoom Effect */}
      <Link to={`/product/${product._id}`} className='block image-zoom overlay-gradient relative'>
        <img
          src={product.image}
          alt={product.name}
          className='w-full h-56 object-cover'
          loading='lazy'
        />
        
        {/* Quick Add to Cart Button - Shows on Hover */}
        {inStock && (
          <button
            onClick={addToCartHandler}
            className='absolute bottom-4 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-y-2 group-hover:translate-y-0 bg-white dark:bg-gray-800 text-gray-900 dark:text-white px-4 py-2 rounded-lg font-semibold shadow-lg hover:shadow-xl flex items-center gap-2 hover:scale-105 active:scale-95'
            aria-label={`Add ${product.name} to cart`}
          >
            <ShoppingCart className='w-4 h-4' />
            Quick Add
          </button>
        )}
      </Link>

      {/* Product Info */}
      <div className='p-4'>
        <Link to={`/product/${product._id}`}>
          <h3 className='font-semibold text-lg mb-2 text-gray-900 dark:text-white group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors line-clamp-2 h-14'>
            {product.name}
          </h3>
        </Link>
        
        <div className='mb-3'>
          <Rating value={product.rating} text={`${product.numReviews} reviews`} />
        </div>
        
        <div className='flex items-center justify-between'>
          <div className='text-2xl font-bold gradient-text'>
            ${product.price}
          </div>
          
          {inStock && (
            <span className='text-xs text-green-600 dark:text-green-400 font-medium'>
              In Stock
            </span>
          )}
        </div>
      </div>
    </div>
  );
};

export default Product;