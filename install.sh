#!/usr/bin/bash

Help()
{
echo
echo "Dynamic IP Updater, version 1.0"
echo "Usage:	install [option]|[long option]"
echo
echo "Options:"
echo "  -i,  --install                 Install Dynamic IP Updater"
echo "  -g,  --generate-config         Generates config file in current directory"
echo "  -h,  --help                    Prints help and info"
echo "  -l,  --licence                 Prints MIT licence"
echo
echo "Home page: https://github.com/musoto96/Dynamic-IP-Updater"
echo
echo
}

Licence()
{
  echo
  echo "MIT License"
  echo
  echo "Copyright (c) 2021, Moises Uriel Soto Pedrero"
  echo
  echo "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:"
  echo
  echo "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."
  echo
  echo "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
  echo
  echo
}

GenerateConfig()
{
  if [ -f ./config.conf ]
  then
    echo "Do you wish to overwrite config.conf in current directory?"
    read -p "" ANS
    case "$ANS" in 
      [Yy] | [Yy][Ee][Ss])
        <config.conf
        ;;
      *)
        echo "Exiting"
        exit;;
    esac
  fi

  echo "Creating config file in config.conf."
  cat <<EOF 1> ./config.conf
#!/usr/bin/bash

RECORD1=(
  DOMAIN="example.com"
  NAME="@"
  TYPE="A"
  TTL="600"
  PORT="1"
  WEIGHT="1"
)

# TODO: Support for multiple records
RECORDS=(\${RECORD1[@]})

for rec in \${RECORDS[@]}
do
  echo \$rec
  declare \$rec
done
EOF

  echo "Edit config.conf with the domain to check and run installer."
}

Install()
{
  if [ "$EUID" -ne 0 ]
  then
    echo "Must have root privileges. Exiting."
    exit
  fi

  if [ ! -f ipCheck.sh ]
  then
    echo "Installation must run from Dynamic-IP-Updater directory. Exiting"
    exit
  fi

  if [ ! -f .credentials ]
  then
    echo "File .credentials not found. Exiting"
    exit
  fi

  if [ ! -d /etc/ipCheck ]
  then
    mkdir /etc/ipCheck
  fi

  echo "Checking config.conf file"
  if [ ! -f ./config.conf ]
  then
    echo "Configuration file missing, creating new one."
    GenerateConfig
    chmod 666 ./config.conf
  exit
  else
    cp ./config.conf /etc/ipCheck/
  fi

  echo "Checking if a service exists under the name ipCheck.service"
  if [ -e /etc/systemd/system/ipCheck.service ]
  then
    echo "Service with name ipCheck.service already exists."
    echo "Run uninstall script to clean previous installations."
    echo "Exiting."
    exit
  fi

  echo "Creating service under the name ipCheck.service"
  cat <<EOF 1> /etc/systemd/system/ipCheck.service
[Unit]
Description=IP monitoring and updating for GoDaddy domain records

[Service]
EnvironmentFile=$PWD/.credentials
ExecStart=$PWD/ipCheck.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

  echo "Enabling service."
  systemctl enable ipCheck.service

  echo "Do you want to start the service now?"
  read -p "" START
  case "$START" in 
    [Yy] | [Yy][Ee][Ss])
      systemctl start ipCheck.service
      ;;
    *)
      echo "You can start the service with the following command \"systemctl start ipCheck.service\""
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
###
