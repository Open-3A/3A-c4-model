FROM node:20-alpine

RUN npm i docsify-cli -g

USER node
WORKDIR /home/node/app
COPY . .
ENTRYPOINT [ "docsify", "serve", "." ]

EXPOSE 3000