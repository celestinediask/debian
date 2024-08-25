#! /bin/bash

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

# # Check if curl is installed
# if ! command -v curl &> /dev/null; then
#     echo "curl is not installed. Installing curl..."
#     sudo apt update && sudo apt install -y curl

#     # Verify if the installation was successful
#     if command -v curl &> /dev/null; then
#         echo "curl has been successfully installed."
#     else
#         echo "Failed to install curl."
#         exit
#     fi
# fi

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "wget is not installed. Installing wget..."
    sudo apt update && sudo apt install -y wget

    # Verify if the installation was successful
    if command -v wget &> /dev/null; then
        echo "wget has been successfully installed."
    else
        echo "Failed to install wget."
        exit
    fi
fi

# Check if gpg is installed
if ! command -v gpg &> /dev/null; then
    echo "gpg is not installed. Installing gpg..."
    sudo apt update && sudo apt install -y gnupg

    # Verify if the installation was successful
    if command -v gpg &> /dev/null; then
        echo "gpg has been successfully installed."
    else
        echo "Failed to install gpg."
        exit
    fi
fi

# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg

sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg

sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

echo "vscode repo added"
