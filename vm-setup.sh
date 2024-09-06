#! bin/sh
# debian virtual machine setup

set -e

# Check if OS is Debian-based
check_os() {
	if ! grep -q "^ID=debian" /etc/os-release; then
		echo "This script is intended for Debian-based distributions only. Exiting."
		exit 1
	fi
}

# Check if running with root privilage
check_root() {
	if [ "$(id -u)" != "0" ]; then
		if ! sudo -n true 2>/dev/null; then
		    echo "This script requires root privileges to execute."
		fi
		
		sudo sh "$0" "$@"
		exit $?
	fi
}

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

# Function to enable autologin for current user in GDM
enable_autologin() {
    # Get current username
    CURRENT_USER=$(whoami)

    # Set GDM configuration file
    GDM_CONFIG_FILE="/etc/gdm3/daemon.conf"

    # Enable autologin for the current user
    sudo sed -i 's/# *\(AutomaticLoginEnable\).*/\1 = true/' $GDM_CONFIG_FILE
    sudo sed -i "s/# *\(AutomaticLogin\).*/\1 = $CURRENT_USER/" $GDM_CONFIG_FILE

    echo "Autologin enabled for $CURRENT_USER."
}

update_system() {
	sudo apt update
	sudo apt upgrade
}

setup_spice() {
	# spice agent
	sudo apt install spice-vdagent
	systemctl status spice-vdagent
	sudo systemctl start spice-vdagent
	sudo systemctl enable spice-vdagent
}

setup_dash() {
	sudo apt install gnome-shell-extension-dashtodock
	gnome-extensions enable dash-to-dock@micxgx.gmail.com
}

main() {
	check_os
	check_root
	comment_out_deb_src
	disable_grub_timeout
	update_system
	enable_autologin
	setup_spice
	setup_dash
}

main
