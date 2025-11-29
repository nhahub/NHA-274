import { Star, StarHalf } from 'lucide-react';

const Rating = ({ value, text }) => {
  return (
    <div className='flex items-center gap-2' role='img' aria-label={`Rating: ${value} out of 5 stars`}>
      <div className='flex items-center gap-0.5'>
        {[1, 2, 3, 4, 5].map((index) => (
          <span key={index} className='transition-transform hover:scale-110 duration-200'>
            {value >= index ? (
              <Star className='w-5 h-5 fill-yellow-400 text-yellow-400 drop-shadow-sm' />
            ) : value >= index - 0.5 ? (
              <StarHalf className='w-5 h-5 fill-yellow-400 text-yellow-400 drop-shadow-sm' />
            ) : (
              <Star className='w-5 h-5 text-gray-300 dark:text-gray-600' />
            )}
          </span>
        ))}
      </div>
      {text && (
        <span className='text-sm text-gray-600 dark:text-gray-400 font-medium'>
          {text}
        </span>
      )}
    </div>
  );
};

export default Rating;