FROM node:12-alpine3.9

WORKDIR /myapp

COPY package.json /myapp/

# Install production dependencies
RUN npm install --production

COPY src/ /myapp/src/

CMD ["node", "src/index.js"]