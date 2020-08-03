FROM node:slim

RUN npm -g install typescript aws-cdk

WORKDIR /app
