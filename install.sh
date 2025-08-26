#!/usr/bin/env bash

source ./install.conf

Help()
{
echo
echo "$PROGRAM, $VERSION"
echo "Usage:  install [option]|[long option]"
echo
echo "Options:"
echo "  -i,  --install                 Install $PROGRAM"
echo "  -g,  --generate-config         Generates config file in current directory"
echo "  -h,  --help                    Prints help and info"
echo "  -l,  --licence                 Prints licence if any"
echo
echo "Home page: https://github.com/musoto96/$REPONAME"
echo
echo
}

GenerateConfig()
{
  if [ -f ./$CONF ]
  then
    echo "Do you wish to overwrite $CONF in current directory?"
    read -p "" ANS
    case "$ANS" in 
      [Yy] | [Yy][Ee][Ss])
        <$CONF
        ;;
      *)
        echo "Exiting"
        exit;;
    esac
  fi

  echo "Creating config file: $CONF."
  cat <<EOF 1> ./$CONF
#!/usr/bin/bash

# Registrar "godaddy" or "namedotcom" including doublequotes
REGISTRAR="namedotcom"
PUBLIC_IP_ENDPOINT_CHECK="https://ipinfo.io/ip"

# Log level
DEBUG="false"

# name.com endpoint
NAMEDOTCOM_ENDPOINT="https://api.name.com/core/v1/domains"

# Godaddy endpoint
GODADDY_ENDPOINT="https://api.godaddy.com/v1/domains"

# Record to monitor
DOMAIN="example.com"
NAME="@"
TYPE="A"
TTL="600"
PORT="1"
WEIGHT="1"
EOF

  echo "Edit $CONF with appropriate paths on your system."
}

Install()
{
  if [ "$EUID" -ne 0 ]
  then
    echo "Must have root privileges. Exiting."
    exit
  fi

  if [ ! -f $SCRIPT ]
  then
    echo "Installation must run from $DAEMON directory. Exiting"
    exit
  fi

  if [ ! -d $ETC ]
  then
    mkdir $ETC
  fi

  echo "Checking $CONF file"
  if [ ! -f ./$CONF ]
  then
    echo "Configuration file missing, creating new one."
    GenerateConfig
    chmod 666 ./$CONF
  exit
  else
    cp ./$CONF $ETC/
  fi

  echo "Checking $CREDENTIALS file"
  if [ ! -f ./$CREDENTIALS ]
  then
    echo "Credentials file missing: $CREDENTIALS"
  exit
  else
    cp ./$CREDENTIALS $ETC/
  fi

  echo "Copying program"
  cp ./$SCRIPT $ETC/

  echo "Checking if a service exists under the name $DAEMON.service"
  if [ -e /etc/systemd/system/$DAEMON.service ]
  then
    echo "Service with name $DAEMON.service already exists."
    echo "Run uninstall script to clean previous installations."
    echo "Exiting."
    exit
  fi

  echo "Creating service under the name $DAEMON.service"
  cat <<EOF 1> /etc/systemd/system/$DAEMON.service
[Unit]
Description=$DESCRIPTION

[Service]
EnvironmentFile=$ETC/$CONF
ExecStart=$ETC/$SCRIPT
Restart=always

[Install]
WantedBy=multi-user.target
EOF


  echo "Enabling service."
  systemctl enable $DAEMON.service

  echo "Do you want to start the service now?"
  read -p "" START
  case "$START" in 
    [Yy] | [Yy][Ee][Ss])
      systemctl start $DAEMON.service
      ;;
    *)
      echo "You can start the service with the following command \"systemctl start $DAEMON.service\""
  esac
  echo "Installation complete"
}

###
while getopts ":ighl" option; do
  case $option in
    i)
      Install
      exit;;
    g)
      GenerateConfig
      exit;;
    h)
      Help
      exit;;
    l)
      Licence
      exit;;
    \?)
      echo 
      echo "Unknown option supplied"
      echo "use -h to see available commands"
      echo 
      exit;;
  esac
done

if [ $OPTIND == 1 ]
then
  Install
fi
