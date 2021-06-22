#!/usr/bin/bash

# Credentials
HEADERS="Authorization: sso-key $KEY:$SECRET"

# Vars
DOMAIN="domain.com"
NAME="@"
TYPE="A"
TTL="3600"
PORT="1"
WEIGHT="1"

# Check for previous known ip
# Service 
while [ true ]
do
  PUB_IP=$(curl -fsX GET https://ipinfo.io/ip)
  EXIT_PUB_IP=$?

  echo "PUB_IP=$PUB_IP"

  RECORD_DATA=$(curl -sfX GET "https://api.godaddy.com/v1/domains/${DOMAIN}/records/${TYPE}/${NAME}" -H "${HEADERS}")
  EXIT_RECORD_DATA=$?

  RECORD_DATA=$(echo $RECORD_DATA | cut -d : -f 2 | cut -d , -f 1)

  DOMAIN_PUB_IP=$(echo $RECORD_DATA | sed -r 's/\"//g')

  echo "DOMAIN_PUB_IP=$DOMAIN_PUB_IP"

  if [ "$EXIT_PUB_IP" == 0 ] && [ "$EXIT_RECORD_DATA" == 0 ]
  then
    if [ "$PUB_IP" != "$DOMAIN_PUB_IP" ]
    then
      echo "IP Changed, updating"
      curl -X PUT "https://api.godaddy.com/v1/domains/${DOMAIN}/records/${TYPE}/${NAME}" \
        -H "accept: application/json" \
        -H "Content-Type: application/json" \
        -H "${HEADERS}" \
        -d "[ { \"data\": \"${PUB_IP}\", 
              \"port\": ${PORT}, 
              \"priority\": 0, 
              \"protocol\": \"string\", 
              \"service\": \"string\", 
              \"ttl\": $TTL, 
              \"weight\": $WEIGHT } ]"
      RES=$?

      if [ "$RES"==0 ]
      then
        echo "IP update success"
        echo "$DOMAIN pointing to $PUB_IP"
      else
        echo "Error updating."
      fi
    else
      echo "IP Unchanged"
    fi
  else
    echo "Awaiting connection"
  fi

  # rate limit 50000/month, approx 1/minute
  sleep 180
done
