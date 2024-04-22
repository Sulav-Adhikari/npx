# Stage 1: Build the Next.js app
FROM node:20-alpine AS build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


FROM node:20-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package*.json ./

RUN npm install 

COPY --from=build /usr/src/app/.next ./.next

EXPOSE 3000

CMD ["npm", "start"]
