const Loader = () => {
  return (
    <div className='flex justify-center items-center py-12'>
      <div className='relative'>
        {/* Background Circle */}
        <div className='w-20 h-20 border-4 border-gray-200 dark:border-gray-700 rounded-full'></div>
        
        {/* Spinning Gradient Circle */}
        <div className='w-20 h-20 border-4 border-transparent border-t-indigo-600 border-r-purple-600 rounded-full animate-spin absolute top-0 left-0'></div>
        
        {/* Inner Pulsing Dot */}
        <div className='absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2'>
          <div className='w-3 h-3 bg-gradient-to-r from-indigo-600 to-purple-600 rounded-full animate-pulse-soft'></div>
        </div>
      </div>
    </div>
  );
};

export default Loader;
