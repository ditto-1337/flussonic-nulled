#!/bin/bash

bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

sudo apt-get install -y xxd -y &>/dev/null
echo "    ________                            _         _   __      ____         __"
echo "   / ____/ /_  ________________  ____  (_)____   / | / /_  __/ / /__  ____/ /"
echo "  / /_  / / / / / ___/ ___/ __ \/ __ \/ / ___/  /  |/ / / / / / / _ \/ __  / "
echo " / __/ / / /_/ (__  |__  ) /_/ / / / / / /__   / /|  / /_/ / / /  __/ /_/ /  "
echo "/_/   /_/\__,_/____/____/\____/_/ /_/_/\___/  /_/ |_/\__,_/_/_/\___/\__,_/   "
echo "  "
echo "  "
echo "${underline}${warn}${bold}--=Flussonic 23.01 Nulled Private Release=--${reset}"
echo "  "
echo "${italic}${bold}Please Select Your Operating System:${reset}"
echo "  "
echo "1. Ubuntu-18.04"
echo "2. Ubuntu-20.04"
echo "3. Ubuntu-22.04"
echo "4. Ubuntu-22.10"
echo "  "

read -p "Enter your choice: " choice

if [ "$choice" == "1" ]; then
echo "  "
echo "${warn}${bold}Flussonic-Erlang Downloading...${reset}"
cd Resources/erlang/
xxd -r -p Ubuntu-18.04.hex > /tmp/flussonic-erlang.deb

elif [ "$choice" == "2" ]; then
echo "  "
echo "${warn}${bold}Flussonic-Erlang Downloading...${reset}"
cd Resources/erlang/
xxd -r -p Ubuntu-20.04.hex > /tmp/flussonic-erlang.deb

elif [ "$choice" == "3" ]; then
echo "  "
echo "${warn}${bold}Flussonic-Erlang Downloading...${reset}"
cd Resources
xxd -r -p libss.hex > /tmp/libss.deb
dpkg -i /tmp/libss.deb &>/dev/null
rm /tmp/libss* &>/dev/null
cd erlang
xxd -r -p Ubuntu-22.04.hex > /tmp/flussonic-erlang.deb
	
elif [ "$choice" == "4" ]; then
echo "  "
echo "${warn}${bold}Flussonic-Erlang Downloading...${reset}"
cd Resources
xxd -r -p libss.hex > /tmp/libss.deb
dpkg -i /tmp/libss.deb &>/dev/null
rm /tmp/libss* &>/dev/null
cd erlang
xxd -r -p Ubuntu-22.10.hex > /tmp/flussonic-erlang.deb

else
echo "${warn}${bold}Invalid choice. Please select either option 1 or 2 or 3 or 4.${reset}"
    exit 1
fi
cd ..
echo "${warn}${bold}Flussonic Downloading...${reset}"
xxd -r -p flussonic.hex > /tmp/flussonic.deb
echo "${warn}${bold}Flussonic-Transcoder Downloading...${reset}"
xxd -r -p flussonic-transcoder.hex > /tmp/flussonic-transcoder.deb
echo "${warn}${bold}Flussonic-Transcoder-Base Downloading...${reset}"
xxd -r -p flussonic-transcoder-base.hex > /tmp/flussonic-transcoder-base.deb
echo "${warn}${bold}Flussonic-QSV Downloading...${reset}"
xxd -r -p flussonic-qsv.hex > /tmp/flussonic-qsv.deb
echo "${warn}${bold}Flussonic-Python Downloading...${reset}"
xxd -r -p flussonic-python.hex > /tmp/flussonic-python.deb
echo "${warn}${bold}Flussonic-Deprecated Downloading...${reset}"
xxd -r -p flussonic-deprecated.hex > /tmp/flussonic-deprecated.deb

echo "  "
echo "${warn}${bold}Uninstalling Previous Versions If any are installed!${reset}"
apt-get purge --auto-remove flussonic flussonic-transcoder flussonic-transcoder-base flussonic-qsv flussonic-python flussonic-deprecated flussonic-erlang flussonic-watcher flussonic-watcher-core -y &>/dev/null 
echo "  "
echo "${warn}${bold}Beginning installation!${reset}"
dpkg -i /tmp/flussonic*.deb &>/dev/null
rm /tmp/flussonic* &>/dev/null
echo "  "

read -p "${warn}${bold}Please enter the desired HTTP port number:${reset} " http_port
read -p "${warn}${bold}Please enter the desired username:${reset} " username
read -p "${warn}${bold}Please enter the desired password:${reset} " password


cat > /etc/flussonic/flussonic.conf <<EOF
# Global settings:
http $http_port;
rtmp 1935;
pulsedb /var/lib/flussonic;
session_log /var/lib/flussonic;
edit_auth $username $password;

# DVRs:

# Remote sources:

# Balancer:

# Stream templates:

# Ingest streams:

# Disk file caches:

# VOD locations:

# DVB cards:

# Components:
iptv;
EOF

echo "  "


service flussonic start
echo "  "
echo "${warn}${bold}Installation Complete!${reset}"

ip_address=$(curl -s https://ifconfig.me)
url="http://$ip_address:$http_port"
echo "${warn}${bold}Server URL: $url${reset}"
echo "${warn}${bold}Username: $username${reset}"
echo "${warn}${bold}Password: $password${reset}"