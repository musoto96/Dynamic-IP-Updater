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
5. Install and start the daemon<br/>
`chmod 744 install.sh && echo "y" | sudo ./install.sh`

### Useful commands
1. You can view daemon state with <br/>
`sudo systemctl status ipCheck.service`
2. Or view trailing logs with <br/>
`sudo journalctl -u ipCheck.service -f`
