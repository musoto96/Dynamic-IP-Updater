#!/usr/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "Must have root privileges. Exiting."
  exit
fi

echo "Uninstalling Dynamic IP Updater"
sudo systemctl stop ipCheck.service && sudo rm /etc/systemd/system/ipCheck.service && echo "Succesfully uninstalled Dynamic IP Updater." && exit
