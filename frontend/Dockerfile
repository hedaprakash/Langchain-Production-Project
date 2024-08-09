FROM node:22-alpine

WORKDIR /app

EXPOSE 3000

COPY package.json package-lock.json ./

RUN npm install --silent
RUN npx update-browserslist-db@latest  

COPY . ./

CMD ["npm", "run", "dev"]