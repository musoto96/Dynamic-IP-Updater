# Dynamic-IP-Updater

### GoDaddy dns ip updater daemon

## Installation
__All commands are run on the Dynamic-IP-Updater directory__
1. Modify `.credentials` with your credentials.
2. Install and start the daemon<br/>
`chmod 744 install.sh && echo "y" | sudo ./install.sh`

### Useful commands
1. You can view daemon state with <br/>
`sudo systemctl status ipCheck.service`
2. Or view trailing logs with <br/>
`sudo journalctl -u ipCheck.service -f`
