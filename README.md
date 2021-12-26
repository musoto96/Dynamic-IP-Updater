# Dynamic-IP-Updater

### GoDaddy dns ip updater daemon

## Installation
__All commands are run on the Dynamic-IP-Updater directory__
1. Modify `.credentials` with your credentials.
2. Run `bash install -g` to generate config file, edit accordingly (currently supports only one record)
3. Install and start the daemon `bash install.sh`
4. View help interface `bash install.sh -h`

## Config file
1. Config file is located in `/etc/ipCheck/config.conf`
2. Edit this file and restart daemon with `systemctl restart ipCheck.service` to apply changes.

### Useful commands
1. You can view daemon state with <br/>
`sudo systemctl status ipCheck.service`
2. Or view trailing logs with <br/>
`sudo journalctl -u ipCheck.service -f`
