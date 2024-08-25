#! bin/sh

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


comment_out_deb_src() {
    # Check if backup file already exists
    if grep -qE '^\s*#.*deb-src' /etc/apt/sources.list; then
        echo "Already deb-src lines have been commented out in /etc/apt/sources.list."
        return
    fi

    # Backup the original sources.list file
    cp -i /etc/apt/sources.list /etc/apt/sources.list.bak

    # Comment out all deb-src lines
    sed -i 's/^\(deb-src.*\)$/#\1/' /etc/apt/sources.list

    echo "All deb-src lines have been commented out in /etc/apt/sources.list."
}

disable_grub_timeout() {
    echo "disabling grub timeout..."
    sudo cp -n /etc/default/grub /etc/default/grub.bak
    sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub

    # update grub
    echo "updating grub..."
    sudo update-grub
}

comment_out_deb_src
#disable_grub_timeout
