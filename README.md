# Kasa-Linux-Powermon

### Linux daemon to monitor battery system battery, and toggle Kasa WIFI Smart Plug on and off

## Prerequisites
__All commands are run on the Kasa-Linux-Powermon directory__
1. Create a virtual environment
`python -m virtualenv .`
2. Activate the environment
`source ./bin/activate`
3. Install requirements (tzdata and python-kasa)
`pip install -r ./requirements.txt`

## Installation
__All commands are run on the Kasa-Linux-Powermon directory__
1. Modify `pwmon_conf` with the path to your battery .
2. Run `bash install -g` to generate a sample config file, edit accordingly.
3. Install and start the daemon `bash install.sh`
4. View help interface `bash install.sh -h`

## Config file
1. Config file is located in `/etc/pwmon/pwmon_conf`
2. Edit this file and restart daemon with `systemctl restart pwmon.service` to apply changes.

### Useful commands
1. You can view daemon state with <br/>
`sudo systemctl status pwmon.service`
2. Or view trailing logs with <br/>
`sudo journalctl -u pwmon.service -f`
