FROM ubuntu

WORKDIR /app

ADD bootstrap.sh .
ADD package.json .

RUN chmod +x bootstrap.sh
RUN ./bootstrap.sh

COPY index.js .

CMD [ "node", "index.js" ]
