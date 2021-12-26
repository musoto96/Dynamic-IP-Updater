#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "Must have root privileges. Exiting."
  exit
fi

echo "Uninstalling Dynamic IP Updater"

echo "Stopping service"
systemctl stop ipCheck.service

echo "Removing service"
rm /etc/systemd/system/ipCheck.service

echo "Reloading daemons"
systemctl daemon-reload

echo "Succesfully uninstalled Dynamic IP Updater."
exit
