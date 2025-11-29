import jwt from 'jsonwebtoken';

const parseBool = (v) => {
  if (v === undefined || v === null) return undefined;
  const s = String(v).toLowerCase().trim();
  if (s === 'true' || s === '1' || s === 'yes') return true;
  if (s === 'false' || s === '0' || s === 'no') return false;
  return undefined;
};

const isCookieSecure = (res) => {

  const envOverride = parseBool(process.env.COOKIE_SECURE);
  if (envOverride === true) return true;
  if (envOverride === false) return false;

  const req = res && res.req;
  if (req) {
    if (req.secure) return true;
    const proto = req.headers && (req.headers['x-forwarded-proto'] || req.headers['X-Forwarded-Proto']);
    if (proto) return proto.split(',')[0].toLowerCase() === 'https';
  }

  return false;
};

const normalizeSameSite = (v) => {
  if (!v) return 'lax';
  const s = String(v).toLowerCase().trim();
  if (s === 'lax' || s === 'strict' || s === 'none') return s;

  return 'lax';
};

const generateToken = (res, userId) => {
  const token = jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: '30d',
  });

  let sameSite = normalizeSameSite(process.env.COOKIE_SAMESITE || process.env.COOKIE_SAME_SITE);

  let secure = isCookieSecure(res);

  if (sameSite === 'none' && !secure) {

    const forceNone = parseBool(process.env.FORCE_SAMESITE_NONE) === true;
    if (forceNone) {

      secure = true;

      console.warn('FORCING SameSite=None and Secure for jwt cookie (FORCE_SAMESITE_NONE=true)');
    } else {

      sameSite = 'lax';

      console.warn('Requested SameSite=None but transport is not secure; downgrading to SameSite=Lax');
    }
  }

  res.cookie('jwt', token, {
    httpOnly: true,
    secure,
    sameSite,
    path: '/',
    maxAge: 30 * 24 * 60 * 60 * 1000, // 30 days
  });
};

export default generateToken;
