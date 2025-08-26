# Dynamic-IP-Updater

  ### name.com and GoDaddy dns record updater daemon

## Installation
__All commands are run on the Dynamic-IP-Updater directory__
1. Modify `.credentials` with your credentials.
2. Run `bash install -g` to generate config file, edit accordingly (currently supports only one record)
3. Install and start the daemon `bash install.sh`
4. View help interface `bash install.sh -h`

## Config file
1. Config file is located in `/etc/ipcheck/ipcheck_conf`
2. Edit this file and restart daemon with `systemctl restart ipcheck.service` to apply changes.

### Useful commands
1. You can view daemon state with <br/>
`sudo systemctl status ipcheck.service`
2. Or view trailing logs with <br/>
`sudo journalctl -u ipcheck.service -f`
