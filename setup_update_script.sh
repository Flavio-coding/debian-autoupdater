#!/bin/bash

# Header
echo "=============================="
echo "         AUTO-UPDATER         "
echo "=============================="
echo "This script will create an update script that runs 'sudo apt update && sudo apt upgrade -y' daily at 16:30."
echo "It will also configure sudo to allow running this script without a password."
echo "After the installation is complete, this script will delete itself."

# Path for the update script
SCRIPT_PATH="/usr/local/bin/update_script.sh"

# Check if the update script is already installed
if [ -f "$SCRIPT_PATH" ]; then
    read -p "The update script is already installed. Do you want to reinstall it? [s/n]: " reinstall_choice
    if [[ "$reinstall_choice" != "s" ]]; then
        echo "Exiting without changes."
        rm -- "$0"  # Auto-delete the script
        exit 0
    fi
fi

# Create the update script
echo "#!/bin/bash" | sudo tee $SCRIPT_PATH > /dev/null
echo "sudo apt update && sudo apt upgrade -y" | sudo tee -a $SCRIPT_PATH > /dev/null

# Make the update script executable
sudo chmod +x $SCRIPT_PATH

# Add the command to the root user's crontab
(crontab -l 2>/dev/null; echo "30 16 * * * $SCRIPT_PATH") | sudo crontab -

# Configure sudo to not require a password for the command
echo "$(whoami) ALL=(ALL) NOPASSWD: $SCRIPT_PATH" | sudo tee /etc/sudoers.d/update_script > /dev/null

# Set the correct permissions
sudo chmod 440 /etc/sudoers.d/update_script

echo "Setup completed! The update script will run every day at 16:30."

# Prompt to reboot the system
read -p "Do you want to reboot the system now? (y/n): " choice
if [[ "$choice" == "y" ]]; then
    echo "Rebooting..."
    sudo reboot
else
    echo "You can reboot the system later to apply changes."
fi

# Delete the installation script
rm -- "$0"
