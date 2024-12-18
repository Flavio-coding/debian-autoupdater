#!/bin/bash

# Inform the user about what the script does
echo "This script will create an update script that runs 'sudo apt update && sudo apt upgrade -y' daily at 16:30."
echo "It will also configure sudo to allow running this script without a password."
echo "After the installation is complete, this script will delete itself."
read -p "Do you want to proceed? (y/n): " choice

if [[ "$choice" != "y" ]]; then
    echo "Exiting the script."
    exit 0
fi

# Path for the update script
SCRIPT_PATH="/usr/local/bin/update_script.sh"

# Create the update script
echo "#!/bin/bash" > $SCRIPT_PATH
echo "sudo apt update && sudo apt upgrade -y" >> $SCRIPT_PATH

# Make the update script executable
chmod +x $SCRIPT_PATH

# Add the command to the root user's crontab
(crontab -l 2>/dev/null; echo "30 16 * * * $SCRIPT_PATH") | crontab -

# Configure sudo to not require a password for the command
echo "$(whoami) ALL=(ALL) NOPASSWD: $SCRIPT_PATH" | sudo tee -a /etc/sudoers.d/update_script

# Set the correct permissions
sudo chmod 440 /etc/sudoers.d/update_script

echo "Setup completed! The update script will run every day at 16:30."

# Delete the installation script
rm -- "$0"
