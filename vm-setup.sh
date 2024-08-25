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

main() {
	enable_autologin
}

main
