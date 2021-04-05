FROM ubuntu

WORKDIR /app

ADD bootstrap.sh .

RUN chmod +x bootstrap.sh
RUN ./bootstrap.sh

ADD package.json .
RUN npm install

COPY ipupdt.js .
COPY .env .

CMD [ "node", "ipupdt.js" ]
