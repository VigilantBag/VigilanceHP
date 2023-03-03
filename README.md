## AICSHP

Another ICS HoneyPot

### Install

#### Install Dependencies:

#### `./installdeps.sh`  
Add the following to crontab:  
`@reboot bash /etc/inotifyfilechange.sh`  
`@reboot bash /etc/start_plc.sh`  
Copy start\_plc.sh to /etc/

### Usage

Web GUI available at [127.0.0.1:8080](127.0.0.1:8080)

Default login: openplc:openplc

  
Restart system or VMs to restart PLC