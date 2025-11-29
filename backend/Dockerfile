FROM node:18-alpine

WORKDIR /usr/src/app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm install --omit=dev --no-audit --no-fund

COPY backend ./backend

RUN mkdir -p uploads

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:5000/api/products', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "backend/server.js"]
