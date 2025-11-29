import { Link } from 'react-router-dom';
import { Facebook, Twitter, Instagram, Linkedin, Mail, Phone, MapPin } from 'lucide-react';

const Footer = () => {
  const currentYear = new Date().getFullYear();
  
  return (
    <footer className='bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 dark:from-gray-950 dark:via-gray-900 dark:to-gray-950 text-white mt-auto'>
      {/* Main Footer Content */}
      <div className='container mx-auto px-4 py-12'>
        <div className='grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8'>
          {/* Brand Section */}
          <div className='space-y-4'>
            <h3 className='text-2xl font-bold gradient-text-warm'>ProShop</h3>
            <p className='text-gray-400 text-sm leading-relaxed'>
              Your one-stop shop for the latest tech products. Quality guaranteed, customer satisfaction first.
            </p>
            <div className='flex gap-3'>
              <a 
                href='https://facebook.com' 
                target='_blank' 
                rel='noopener noreferrer'
                className='p-2 bg-gray-800 hover:bg-indigo-600 rounded-lg transition-all duration-300 hover:scale-110'
                aria-label='Facebook'
              >
                <Facebook className='w-5 h-5' />
              </a>
              <a 
                href='https://twitter.com' 
                target='_blank' 
                rel='noopener noreferrer'
                className='p-2 bg-gray-800 hover:bg-indigo-600 rounded-lg transition-all duration-300 hover:scale-110'
                aria-label='Twitter'
              >
                <Twitter className='w-5 h-5' />
              </a>
              <a 
                href='https://instagram.com' 
                target='_blank' 
                rel='noopener noreferrer'
                className='p-2 bg-gray-800 hover:bg-indigo-600 rounded-lg transition-all duration-300 hover:scale-110'
                aria-label='Instagram'
              >
                <Instagram className='w-5 h-5' />
              </a>
              <a 
                href='https://linkedin.com' 
                target='_blank' 
                rel='noopener noreferrer'
                className='p-2 bg-gray-800 hover:bg-indigo-600 rounded-lg transition-all duration-300 hover:scale-110'
                aria-label='LinkedIn'
              >
                <Linkedin className='w-5 h-5' />
              </a>
            </div>
          </div>

          {/* Quick Links */}
          <div className='space-y-4'>
            <h4 className='text-lg font-semibold text-white'>Quick Links</h4>
            <ul className='space-y-2'>
              <li>
                <Link to='/' className='text-gray-400 hover:text-indigo-400 transition-colors text-sm'>
                  Home
                </Link>
              </li>
              <li>
                <Link to='/cart' className='text-gray-400 hover:text-indigo-400 transition-colors text-sm'>
                  Shopping Cart
                </Link>
              </li>
              <li>
                <Link to='/login' className='text-gray-400 hover:text-indigo-400 transition-colors text-sm'>
                  Sign In
                </Link>
              </li>
              <li>
                <Link to='/register' className='text-gray-400 hover:text-indigo-400 transition-colors text-sm'>
                  Register
                </Link>
              </li>
            </ul>
          </div>

          {/* Customer Service */}
          <div className='space-y-4'>
            <h4 className='text-lg font-semibold text-white'>Customer Service</h4>
            <ul className='space-y-2'>
              <li className='flex items-center gap-2 text-gray-400 text-sm'>
                <Mail className='w-4 h-4 text-indigo-400' />
                support@proshop.com
              </li>
              <li className='flex items-center gap-2 text-gray-400 text-sm'>
                <Phone className='w-4 h-4 text-indigo-400' />
                +1 (555) 123-4567
              </li>
              <li className='flex items-start gap-2 text-gray-400 text-sm'>
                <MapPin className='w-4 h-4 text-indigo-400 mt-0.5' />
                <span>123 Tech Street<br />San Francisco, CA 94102</span>
              </li>
            </ul>
          </div>

          {/* Newsletter */}
          <div className='space-y-4'>
            <h4 className='text-lg font-semibold text-white'>Stay Updated</h4>
            <p className='text-gray-400 text-sm'>
              Subscribe to our newsletter for the latest deals and updates.
            </p>
            <div className='flex gap-2'>
              <input
                type='email'
                placeholder='Your email'
                className='flex-1 px-3 py-2 bg-gray-800 border border-gray-700 rounded-lg text-sm focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-500/20 transition-all'
              />
              <button className='px-4 py-2 bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 rounded-lg font-semibold text-sm transition-all hover:scale-105 active:scale-95'>
                Subscribe
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Bar */}
      <div className='border-t border-gray-800'>
        <div className='container mx-auto px-4 py-6'>
          <div className='flex flex-col md:flex-row justify-between items-center gap-4'>
            <p className='text-gray-400 text-sm'>
              &copy; {currentYear} ProShop. All rights reserved.
            </p>
            <div className='flex items-center gap-4'>
              <span className='text-gray-400 text-xs'>We accept:</span>
              <div className='flex gap-2'>
                <div className='px-3 py-1 bg-gray-800 rounded text-xs font-semibold'>VISA</div>
                <div className='px-3 py-1 bg-gray-800 rounded text-xs font-semibold'>MC</div>
                <div className='px-3 py-1 bg-gray-800 rounded text-xs font-semibold'>AMEX</div>
                <div className='px-3 py-1 bg-gray-800 rounded text-xs font-semibold'>PayPal</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
