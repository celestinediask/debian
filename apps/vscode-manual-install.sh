# shell script to install vscode in debian system

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

wget -O /tmp/code-insiders.deb "https://code.visualstudio.com/sha/download?build=insider&os=linux-deb-x64"

sudo apt install /tmp/code-insiders.deb
