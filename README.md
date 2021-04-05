# Dynamic-IP-Updater

### Currently supporting only noip personal hostnames

## Requirements
1. Docker
2. NodeJS

## Installation
__All commands are run on the Dynamic-IP-Updater directory__
1. Install npm packages <br/>
`npm install`
2. Modify `.env` with your credentials.
3. Open `ipupdt.js` with a text editor and search for `SETUP START` and update the link accordingly.
4. Build docker image using Dockerfile <br/>
`docker build -t ipupdt ./`
5. Install daemon and start the service<br/>
`echo "y" | chmod 744 install.sh && sudo ./install.sh`

### Useful commands
1. You can monitor the daemon state with <br/>
`sudo systemctl status ipCheck.service`
2. Or view trailing logs on the service status <br/>
`sudo journalctl -u ipCheck.service -f`
