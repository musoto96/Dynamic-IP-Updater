#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "Must have root privileges. Exiting."
  exit
fi

if [ ! -e ipCheck.sh ]
then
  echo "Installation must run from Dynamic-IP-Updater directory. Exiting"
  exit
fi

if [ ! -e .credentials ]
then
  echo "File .credentials not found. Exiting"
  exit
fi

echo "Checking if a service exists under the name ipCheck.service"
if [ -e /etc/systemd/system/ipCheck.service ]
then
  echo "Service with name ipCheck.service already exists. Exiting."
  exit
fi

echo "Creating service under the name ipCheck.service"
cat <<EOF > /etc/systemd/system/ipCheck.service
[Unit]
Description=IP monitoring and updating for noip.com personal hostnames

[Service]
EnvironmentFile=$PWD/.credentials
ExecStart=$PWD/ipCheck.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Do you want to start the service now?"
read -p "" START
case "$START" in 
  [Yy] | [Yy][Ee][Ss])
    systemctl start ipCheck.service
    ;;
  *)
    echo "You can start the service with the following command \"systemctl start ipCheck.service\""
esac
echo "Installaton complete"
