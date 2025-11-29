import { AlertCircle, CheckCircle, Info, XCircle } from 'lucide-react';

const Message = ({ variant = 'info', children }) => {
  const variants = {
    success: {
      bg: 'bg-green-50 dark:bg-green-900/20',
      border: 'border-green-200 dark:border-green-800',
      text: 'text-green-800 dark:text-green-200',
      icon: <CheckCircle className='w-5 h-5' />,
    },
    danger: {
      bg: 'bg-red-50 dark:bg-red-900/20',
      border: 'border-red-200 dark:border-red-800',
      text: 'text-red-800 dark:text-red-200',
      icon: <XCircle className='w-5 h-5' />,
    },
    warning: {
      bg: 'bg-yellow-50 dark:bg-yellow-900/20',
      border: 'border-yellow-200 dark:border-yellow-800',
      text: 'text-yellow-800 dark:text-yellow-200',
      icon: <AlertCircle className='w-5 h-5' />,
    },
    info: {
      bg: 'bg-blue-50 dark:bg-blue-900/20',
      border: 'border-blue-200 dark:border-blue-800',
      text: 'text-blue-800 dark:text-blue-200',
      icon: <Info className='w-5 h-5' />,
    },
  };

  const style = variants[variant] || variants.info;

  return (
    <div
      className={`${style.bg} ${style.border} ${style.text} border rounded-lg p-4 flex items-start gap-3`}
    >
      {style.icon}
      <div className='flex-1'>{children}</div>
    </div>
  );
};

export default Message;