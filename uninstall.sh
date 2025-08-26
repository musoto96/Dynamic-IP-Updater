#!/usr/bin/env bash

source ./install.conf

if [ "$EUID" -ne 0 ]
then
  echo "Must have root privileges. Exiting."
  exit
fi

echo "Uninstalling $PROGRAM"

echo "Stopping service"
systemctl stop $DAEMON.service

echo "Removing service"
rm /etc/systemd/system/$DAEMON.service

echo "Reloading daemons"
systemctl daemon-reload

echo "Succesfully uninstalled $PROGRAM."
exit
