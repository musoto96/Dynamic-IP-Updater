#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "Must have root privileges. Exiting."
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
[Service]
ExecStart=$PWD/ipCheck.sh
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
