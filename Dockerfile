FROM ubuntu

ADD bootstrap.sh .
ADD package.json .

RUN chmod +x bootstrap.sh
RUN ./bootstrap.sh

CMD [ "node", "index.js" ]
