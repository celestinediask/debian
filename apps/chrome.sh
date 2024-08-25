#! /bin/bash
# add chrome repo debian

# tested on debian-12.6-gnome-core

set -e

# Check if OS is Debian-based
if ! grep -q "^ID=debian" /etc/os-release; then
    echo "This script is intended for Debian-based distributions only. Exiting."
    exit 1
fi

# Check if running with root privilage
if [ "$(id -u)" != "0" ]; then
    if ! sudo -n true 2>/dev/null; then
        echo "This script requires root privileges to execute."
    fi
    
    sudo sh "$0" "$@"
    exit $?
fi

wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null

sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

echo "chrome repo added"
