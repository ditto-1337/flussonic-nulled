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

#!/bin/bash

read -p "${warn}${bold}Do you want to install this? (y/n)${reset}" answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "${warn}${bold}Installing...${reset}"
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update -y
    sudo apt-get -y install postgresql-9.6
    cd Resources
    xxd -r -p flussonic-watcher-core.hex > /tmp/flussonic-watcher-core.deb
    xxd -r -p flussonic-watcher.hex > /tmp/flussonic-watcher.deb
    dpkg -i /tmp/flussonic*.deb &>/dev/null
    apt --fix-broken install -y
    read -p "${warn}${bold}Enter the password for the user 'vsaas${reset}': " user_password
    sudo -u postgres -i createuser -P vsaas
    sudo -u postgres -i createdb -O vsaas -e -E UTF8 -T template0 vsaas_production

echo "vsaas {" | sudo tee -a /etc/flussonic/flussonic.conf
echo "  database postgresql://vsaas:$user_password@localhost/vsaas_production;" | sudo tee -a /etc/flussonic/flussonic.conf
echo "  endpoint enabled;" | sudo tee -a /etc/flussonic/flussonic.conf
echo "}" | sudo tee -a /etc/flussonic/flussonic.conf
else
    echo "${warn}${bold}Exiting without Installing.${reset}"
    exit
fi
service flussonic restart
echo "  "
echo ${warn}${bold}"Installation Complete... The line below please copy this in to You're Flussonic ip Cameras Settings${reset}"
echo "  "
echo "${warn}${bold}postgresql://vsaas:$user_password@localhost/vsaas_production${reset}"
echo "  "