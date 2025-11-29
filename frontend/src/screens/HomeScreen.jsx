import { useParams, Link } from 'react-router-dom';
import { ArrowLeft } from 'lucide-react';
import { useGetProductsQuery } from '../slices/productsApiSlice';
import Product from '../components/Product';
import Loader from '../components/Loader';
import Message from '../components/Message';
import Paginate from '../components/Paginate';
import ProductCarousel from '../components/ProductCarousel';
import Meta from '../components/Meta';

const HomeScreen = () => {
  const { pageNumber, keyword } = useParams();
  const { data, isLoading, error } = useGetProductsQuery({
    keyword,
    pageNumber,
  });

  return (
    <>
      {!keyword ? (
        <ProductCarousel />
      ) : (
        <Link
          to='/'
          className='inline-flex items-center gap-2 mb-6 px-4 py-2.5 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 rounded-lg shadow-soft hover:shadow-soft-lg transition-all hover:-translate-y-0.5 group'
        >
          <ArrowLeft className='w-4 h-4 group-hover:-translate-x-1 transition-transform' />
          Go Back
        </Link>
      )}
      {isLoading ? (
        <Loader />
      ) : error ? (
        <Message variant='danger'>
          {error?.data?.message || error.error}
        </Message>
      ) : (
        <>
          <Meta />
          <div className='mb-8'>
            <h1 className='text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-2'>
              Latest Products
            </h1>
            <p className='text-gray-600 dark:text-gray-400 text-lg'>
              Discover our newest arrivals and best deals
            </p>
          </div>
          
          <div className='grid gap-6 grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4'>
            {data.products.map((product, index) => (
              <div 
                key={product._id}
                style={{ animationDelay: `${index * 0.1}s` }}
              >
                <Product product={product} />
              </div>
            ))}
          </div>
          
          <div className='mt-12'>
            <Paginate
              pages={data.pages}
              page={data.page}
              keyword={keyword ? keyword : ''}
            />
          </div>
        </>
      )}
    </>
  );
};

export default HomeScreen;