import { useState, useEffect, useRef } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { ShoppingCart, User, Menu, X, LogOut, Package, Settings, Sun, Moon, ChevronDown, ShoppingBag } from 'lucide-react';
import { useLogoutMutation } from '../slices/usersApiSlice';
import { logout } from '../slices/authSlice';
import { resetCart } from '../slices/cartSlice';
import { toast } from 'react-toastify';
import SearchBox from './SearchBox';

const Header = () => {
  const [menuOpen, setMenuOpen] = useState(false);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [adminDropdownOpen, setAdminDropdownOpen] = useState(false);
  
  const userDropdownRef = useRef(null);
  const adminDropdownRef = useRef(null);
  
  // Dark mode state
  const [darkMode, setDarkMode] = useState(() => {
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme) {
      return savedTheme === 'dark';
    }
    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  });

  // Apply dark mode
  useEffect(() => {
    const root = document.documentElement;
    if (darkMode) {
      root.classList.add('dark');
      localStorage.setItem('theme', 'dark');
    } else {
      root.classList.remove('dark');
      localStorage.setItem('theme', 'light');
    }
  }, [darkMode]);

  // Close dropdowns when clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (userDropdownRef.current && !userDropdownRef.current.contains(event.target)) {
        setUserDropdownOpen(false);
      }
      if (adminDropdownRef.current && !adminDropdownRef.current.contains(event.target)) {
        setAdminDropdownOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const toggleTheme = () => {
    setDarkMode(!darkMode);
  };
  
  const { cartItems } = useSelector((state) => state.cart);
  const { userInfo } = useSelector((state) => state.auth);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const [logoutApiCall] = useLogoutMutation();

  const logoutHandler = async () => {
    try {
      await logoutApiCall().unwrap();
      dispatch(logout());
      dispatch(resetCart());
      navigate('/login');
      toast.success('Logged out successfully');
    } catch (err) {
      toast.error(err?.data?.message || err.error || 'Logout failed');
    }
  };

  return (
    <header className='glass-strong shadow-soft sticky top-0 z-50 border-b border-gray-200 dark:border-gray-700'>
      <div className='container mx-auto px-4'>
        <div className='flex items-center justify-between h-16'>
          {/* Logo */}
          <Link to='/' className='text-2xl font-bold text-indigo-600 dark:text-indigo-400'>
            ProShop
          </Link>

          {/* Desktop Navigation */}
          <nav className='hidden lg:flex items-center gap-6'>
            <SearchBox />
            
            <Link
              to='/cart'
              className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400 transition relative'
            >
              <ShoppingCart className='w-5 h-5' />
              Cart
              {cartItems.length > 0 && (
                <span className='absolute -top-2 -right-2 bg-green-500 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center'>
                  {cartItems.reduce((a, c) => a + c.qty, 0)}
                </span>
              )}
            </Link>

            {userInfo ? (
              <div className='relative' ref={userDropdownRef}>
                <button 
                  onClick={() => setUserDropdownOpen(!userDropdownOpen)}
                  className='flex items-center gap-2 px-3 py-2 text-black-700 dark:text-black-300 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition'
                >
                  <div className='w-8 h-8 bg-indigo-100 dark:bg-indigo-900 rounded-full flex items-center justify-center'>
                    <User className='w-5 h-5 text-indigo-600 dark:text-indigo-400' />
                  </div>
                  <span className='font-medium'>{userInfo.name}</span>
                  <ChevronDown className={`w-4 h-4 transition-transform ${userDropdownOpen ? 'rotate-180' : ''}`} />
                </button>
                
                {userDropdownOpen && (
                  <div className='absolute right-0 mt-2 w-64 glass-strong rounded-lg shadow-xl overflow-hidden animate-scale-in'>
                    {/* User Info Section */}
                    <div className='px-4 py-3 bg-gradient-to-r from-indigo-50 to-purple-50 dark:from-indigo-900/20 dark:to-purple-900/20 border-b border-gray-200 dark:border-gray-700'>
                      <div className='flex items-center gap-3'>
                        <div className='w-10 h-10 bg-indigo-600 dark:bg-indigo-500 rounded-full flex items-center justify-center'>
                          <span className='text-white font-bold text-lg'>
                            {userInfo.name.charAt(0).toUpperCase()}
                          </span>
                        </div>
                        <div className='flex-1 min-w-0'>
                          <p className='text-sm font-semibold text-black-900 dark:text-black truncate'>
                            {userInfo.name}
                          </p>
                          <p className='text-xs text-black-500 dark:text-black-400 truncate'>
                            {userInfo.email}
                          </p>
                        </div>
                      </div>
                    </div>

                    {/* Menu Items */}
                    <div className='py-2'>
                      <Link
                        to='/profile'
                        onClick={() => setUserDropdownOpen(false)}
                        className='flex items-center gap-3 px-4 py-2.5 text-black-700 dark:text-black-300 hover:bg-indigo-50 dark:hover:bg-gray-700 transition group'
                      >
                        <Settings className='w-5 h-5 text-black-400 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition' />
                        <span className='font-medium'>My Profile</span>
                      </Link>

                      <Link
                        to='/profile'
                        onClick={() => setUserDropdownOpen(false)}
                        className='flex items-center gap-3 px-4 py-2.5 text-black-700 dark:text-black-300 hover:bg-indigo-50 dark:hover:bg-gray-700 transition group'
                      >
                        <ShoppingBag className='w-5 h-5 text-black-400 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition' />
                        <span className='font-medium'>My Orders</span>
                      </Link>
                    </div>

                    {/* Logout Button */}
                    <div className='border-t border-gray-200 dark:border-gray-700 py-2'>
                      <button
                        onClick={() => {
                          setUserDropdownOpen(false);
                          logoutHandler();
                        }}
                        className='flex items-center gap-3 px-4 py-2.5 w-full text-left text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 transition group'
                      >
                        <LogOut className='w-5 h-5' />
                        <span className='font-medium'>Logout</span>
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <Link
                to='/login'
                className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400 transition'
              >
                <User className='w-5 h-5' />
                Sign In
              </Link>
            )}

            {userInfo && userInfo.isAdmin && (
              <div className='relative' ref={adminDropdownRef}>
                <button 
                  onClick={() => setAdminDropdownOpen(!adminDropdownOpen)}
                  className='flex items-center gap-2 px-3 py-2 text-black-700 dark:text-black-300 bg-gray-50 dark:bg-gray-700 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 transition'
                >
                  <Settings className='w-5 h-5' />
                  Admin
                  <ChevronDown className={`w-4 h-4 transition-transform ${adminDropdownOpen ? 'rotate-180' : ''}`} />
                </button>
                
                {adminDropdownOpen && (
                  <div className='absolute right-0 mt-2 w-48 glass-strong rounded-lg shadow-xl py-2 overflow-hidden animate-scale-in'>
                    <Link
                      to='/admin/productlist'
                      onClick={() => setAdminDropdownOpen(false)}
                      className='block px-4 py-2.5 text-black-700 dark:text-black-300 hover:bg-indigo-50 dark:hover:bg-gray-700 transition'
                    >
                      Products
                    </Link>
                    <Link
                      to='/admin/orderlist'
                      onClick={() => setAdminDropdownOpen(false)}
                      className='block px-4 py-2.5 text-black-700 dark:text-black-300 hover:bg-indigo-50 dark:hover:bg-gray-700 transition'
                    >
                      Orders
                    </Link>
                    <Link
                      to='/admin/userlist'
                      onClick={() => setAdminDropdownOpen(false)}
                      className='block px-4 py-2.5 text-black-700 dark:text-black-300 hover:bg-indigo-50 dark:hover:bg-gray-700 transition'
                    >
                      Users
                    </Link>
                  </div>
                )}
              </div>
            )}

            {/* Theme Toggle Button */}
            <button
              onClick={toggleTheme}
              className='p-2 rounded-md bg-gray-200 dark:bg-gray-700 hover:bg-gray-300 dark:hover:bg-gray-600 transition'
              aria-label='Toggle theme'
            >
              {darkMode ? (
                <Sun className='w-5 h-5 text-yellow-400' />
              ) : (
                <Moon className='w-5 h-5 text-black-600' />
              )}
            </button>
          </nav>

          {/* Mobile Menu Button */}
          <button
            onClick={() => setMenuOpen(!menuOpen)}
            className='lg:hidden p-2 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition'
          >
            {menuOpen ? (
              <X className='w-6 h-6 text-black-700 dark:text-black-300' />
            ) : (
              <Menu className='w-6 h-6 text-black-700 dark:text-black-300' />
            )}
          </button>
        </div>

        {/* Mobile Menu */}
        {menuOpen && (
          <div className='lg:hidden pb-4 border-t border-gray-200 dark:border-gray-700 mt-2 pt-4 animate-slide-in-left'>
            <div className='flex flex-col gap-4'>
              <SearchBox />
              
              <Link
                to='/cart'
                className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400'
                onClick={() => setMenuOpen(false)}
              >
                <ShoppingCart className='w-5 h-5' />
                Cart
                {cartItems.length > 0 && (
                  <span className='bg-green-500 text-white text-xs font-bold rounded-full px-2 py-1'>
                    {cartItems.reduce((a, c) => a + c.qty, 0)}
                  </span>
                )}
              </Link>

              {userInfo ? (
                <>
                  <div className='border-t border-gray-200 dark:border-gray-700 pt-4 mt-2'>
                    <div className='flex items-center gap-3 mb-3 px-2'>
                      <div className='w-10 h-10 bg-indigo-600 dark:bg-indigo-500 rounded-full flex items-center justify-center'>
                        <span className='text-white font-bold text-lg'>
                          {userInfo.name.charAt(0).toUpperCase()}
                        </span>
                      </div>
                      <div className='flex-1 min-w-0'>
                        <p className='text-sm font-semibold text-black-900 dark:text-black truncate'>
                          {userInfo.name}
                        </p>
                        <p className='text-xs text-black-500 dark:text-black-400 truncate'>
                          {userInfo.email}
                        </p>
                      </div>
                    </div>
                  </div>
                  
                  <Link
                    to='/profile'
                    className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400'
                    onClick={() => setMenuOpen(false)}
                  >
                    <Settings className='w-5 h-5' />
                    My Profile
                  </Link>
                  
                  <Link
                    to='/profile'
                    className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400'
                    onClick={() => setMenuOpen(false)}
                  >
                    <ShoppingBag className='w-5 h-5' />
                    My Orders
                  </Link>
                  
                  <button
                    onClick={() => {
                      logoutHandler();
                      setMenuOpen(false);
                    }}
                    className='flex items-center gap-2 text-red-600 dark:text-red-400 hover:text-red-700 dark:hover:text-red-300 text-left'
                  >
                    <LogOut className='w-5 h-5' />
                    Logout
                  </button>
                </>
              ) : (
                <Link
                  to='/login'
                  className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400'
                  onClick={() => setMenuOpen(false)}
                >
                  <User className='w-5 h-5' />
                  Sign In
                </Link>
              )}

              {userInfo && userInfo.isAdmin && (
                <>
                  <div className='border-t border-gray-200 dark:border-gray-700 pt-4 mt-2'>
                    <p className='text-sm font-semibold text-black-500 dark:text-black-400 mb-2'>
                      Admin Menu
                    </p>
                    <Link
                      to='/admin/productlist'
                      className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400 mb-2'
                      onClick={() => setMenuOpen(false)}
                    >
                      <Package className='w-5 h-5' />
                      Products
                    </Link>
                    <Link
                      to='/admin/orderlist'
                      className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400 mb-2'
                      onClick={() => setMenuOpen(false)}
                    >
                      <ShoppingBag className='w-5 h-5' />
                      Orders
                    </Link>
                    <Link
                      to='/admin/userlist'
                      className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400'
                      onClick={() => setMenuOpen(false)}
                    >
                      <User className='w-5 h-5' />
                      Users
                    </Link>
                  </div>
                </>
              )}

              {/* Theme Toggle - Mobile */}
              <button
                onClick={toggleTheme}
                className='flex items-center gap-2 text-black-700 dark:text-black-300 hover:text-indigo-600 dark:hover:text-indigo-400'
              >
                {darkMode ? (
                  <>
                    <Sun className='w-5 h-5 text-yellow-400' />
                    Light Mode
                  </>
                ) : (
                  <>
                    <Moon className='w-5 h-5' />
                    Dark Mode
                  </>
                )}
              </button>
            </div>
          </div>
        )}
      </div>
    </header>
  );
};

export default Header;