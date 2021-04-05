#!/usr/bin/bash

# Docker container name (change to desired name)
DOCKER_CN=ipupdt:latest

# Check for previous known ip
TEMPFILE=/tmp/ipCheck-daemon-ip
if [ -e "$TEMPFILE" ]
then
  echo "$TEMPFILE found sourcing now"
  cat $TEMPFILE
  source $TEMPFILE
else
  PREV_PUB_IP=$(curl -s https://ipinfo.io/ip)
  echo "PREV_PUB_IP=$PREV_PUB_IP" > $TEMPFILE
  sleep 180
fi

# Service 
while [ true ]
do
  source $TEMPFILE
  PUB_IP=$(curl -s https://ipinfo.io/ip)

  if [ "$PREV_PUB_IP" != "$PUB_IP" ]
  then
    echo "IP Changed, updating"
    docker run --rm $DOCKER_CN node ipupdt $PUB_IP
    RES=$?
    
    if [ "$RES"==0 ]
    then
      echo "IP update success"
      echo "PREV_PUB_IP=$PUB_IP" > $TEMPFILE
    else
      echo "Error in docker: $DOCKER_CN"
    fi
  fi

  # rate limit 50000/month, approx 1/minute
  sleep 180
done
