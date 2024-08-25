# debian install chrome manualy
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

wget -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo apt install -y /tmp/google-chrome-stable_current_amd64.deb

sudo rm /tmp/google-chrome-stable_current_amd64.deb

echo "chrome installed"
