#!/usr/bin/env bash

# Environment variables
SCRIPT_DIR=$(dirname $0)
WORKDIR=$(cd $SCRIPT_DIR; echo $PWD)

# Load config variables
source $WORKDIR/ipcheck_conf

# Load credentials
source $WORKDIR/.credentials
CREDENTIALS="$KEY_OR_USERNAME:$SECRET_OR_TOKEN"

# Helper functions
# name.com
namedotcom_update_record () {
  curl -sfX PUT \
    "$NAMEDOTCOM_ENDPOINT/$DOMAIN/records/$RECORD_ID" \
    -u $CREDENTIALS \
    -H 'Content-Type: application/json' \
    -d "{ \"answer\": \"$PUB_IP\",
          \"fqdn\": \"$NAME.$DOMAIN\",
          \"host\": \"$NAME\",
          \"priority\": 0,
          \"ttl\": $TTL,
          \"type\": \"$TYPE\"
        }"
}

namedotcom_get_record () {
  RECORD=$(curl -sfX GET \
    "$NAMEDOTCOM_ENDPOINT/$DOMAIN/records?" \
    -u $CREDENTIALS \
    |jq '.records[]' \
    |grep -A1 -B2 $NAME)
  log "debug" "$RECORD"

  RECORD_IP=$(echo $RECORD |grep -oE "[0-9]{3}\.[0-9]{3}\.[0-9]{3}\.[0-9]{3}")
  RECORD_ID=$(echo $RECORD |grep -oE "[0-9]{9}")
  log "debug" "RECORD_IP=$RECORD_IP
       RECORD_ID=$RECORD_ID"
}

# Godaddy
godaddy_update_record () {
  curl -X PUT \
    "$GODADDY_ENDPOINT/$DOMAIN/records/$TYPE/$NAME" \
    -H "Authorization: sso-key $CREDENTIALS" \
    -H "Content-Type: application/json" \
    -d "{ \"data\": \"$PUB_IP\", 
          \"port\": $PORT, 
          \"priority\": 0, 
          \"protocol\": \"string\", 
          \"service\": \"string\", 
          \"ttl\": $TTL, 
          \"weight\": $WEIGHT
        }"
}

godaddy_get_record () {
  curl -sfX GET \
    "$GODADDY_ENDPOINT/$DOMAIN/records/$TYPE/$NAME" \
    -H "Authorization: sso-key $CREDENTIALS" \
    |cut -d : -f 2 | cut -d , -f 1 \
    |sed -r 's/\"//g'
}

log () {
  case $1 in
    debug)
      if [ $DEBUG = "true" ]; then
        echo "DEBUG: $2"
      fi
      ;;
    info)
      echo "INFO: $2"
      ;;
    error)
      echo "ERROR: $2"
      ;;
    banner)
      echo 
      echo "INFO: $2"
      echo 
      ;;
    *)
      echo "USPEC: $2"
      ;;
  esac
}


# Log banner info info
start_msg="Variables configured on $WORKDIR/ipcheck_conf:
      REGISTRAR=$REGISTRAR
      DOMAIN=$DOMAIN
      NAME=$NAME"
log "banner" "$start_msg"


# Entrypoint, main loop
while [ true ]
do
  # Get curret public ip
  PUB_IP=$(curl -fsX GET $PUBLIC_IP_ENDPOINT_CHECK)
  EXIT_PUB_IP=$?

  # Check current record IP
  case $REGISTRAR in
    namedotcom)
      namedotcom_get_record
      ;;
    godaddy)
      godaddy_get_record
      ;;
  esac
  EXIT_RECORD_IP=$?

  log "debug" "PUB_IP=$PUB_IP
       RECORD_IP=$RECORD_IP"

  # Check if all requests succeded
  if [ "$EXIT_PUB_IP" == 0 ] && [ "$EXIT_RECORD_IP" == 0 ]
  then
    # Comparre current IP against record data
    if [ "$PUB_IP" != "$RECORD_IP" ]
    then

      log "info" "IP Changed from $RECORD_IP to $PUB_IP Updating"
      case $REGISTRAR in
        namedotcom)
          namedotcom_update_record
          ;;
        godaddy)
          godaddy_update_record
          ;;
      esac
      RES=$?

      if [ "$RES"==0 ]
      then
        log "banner" "IP update success
       $DOMAIN pointing to $PUB_IP"
      else
        log "error" "Error updating."
      fi
    else
      log "debug" "IP Unchanged"
    fi
  else
    log "info" "Awaiting conection"
    [ $EXIT_PUB_IP == 0 ] || log "error" "Public IP request failed EXIT_PUB_IP=$EXIT_PUB_IP"
    [ $EXIT_RECORD_IP == 0 ] || log "error" "Record GET request failed EXIT_RECORD_IP=$EXIT_RECORD_IP"
  fi
  # One request every 3 minutes
  sleep 180
done
