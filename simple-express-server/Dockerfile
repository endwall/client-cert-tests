FROM node:6-slim

ARG build_time
ARG build_version

LABEL BUILD_TIME=${build_time}
LABEL BUILD_VERSION=${build_version}

RUN mkdir -p /opt/app/simple-express-server
COPY . /opt/app/simple-express-server

WORKDIR /opt/app/simple-express-server

RUN npm install

EXPOSE 3000

CMD ["npm", "start"]
