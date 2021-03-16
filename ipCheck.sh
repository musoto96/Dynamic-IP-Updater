#!/usr/bin/bash

# Check for previous known ip
if [ -e ip.txt ]
then
  source ip.txt
  echo $PREV_PUB_IP
fi

# Service 
while [ true ]
do
  PUB_IP=$(curl -s https://ipinfo.io/ip)
  echo $PUB_IP

  if [ "$PREV_PUB_IP" != "$PUB_IP" ]
  then
    echo "IP Changed, run program"
    echo "PREV_PUB_IP=$PUB_IP" > ip.txt
    PREV_PUB_IP=$PUB_IP
  fi

  # rate limit 50000/month, approx 1/minute
  sleep 180
done
