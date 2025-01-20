#!/bin/bash

# Header
echo "=============================="
echo "         AUTO-UPDATER         "
echo "=============================="
echo "This script will create an update script that runs 'sudo apt update && sudo apt upgrade -y' daily at the time you specify."
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

# Ask user for the hour in 24-hour format
while true; do
    read -p "Please enter the hour in 24-hour format (00-23): " hour
    # Check if the hour is valid
    if [[ "$hour" =~ ^([01]?[0-9]|2[0-3])$ ]]; then
        break
    else
        echo "Invalid hour. Please enter a valid hour between 00 and 23."
    fi
done

# Ask user for the minutes (00-59)
while true; do
    read -p "Please enter the minutes (00-59): " minute
    # Check if the minutes are valid
    if [[ "$minute" =~ ^([0-5]?[0-9])$ ]]; then
        break
    else
        echo "Invalid minutes. Please enter valid minutes between 00 and 59."
    fi
done

# Create the update script
echo "#!/bin/bash" | sudo tee $SCRIPT_PATH > /dev/null
echo "sudo apt update && sudo apt upgrade -y" | sudo tee -a $SCRIPT_PATH > /dev/null

# Make the update script executable
sudo chmod +x $SCRIPT_PATH

# Add the command to the root user's crontab
(crontab -l 2>/dev/null; echo "$minute $hour * * * $SCRIPT_PATH") | sudo crontab -

# Configure sudo to not require a password for the command
echo "$(whoami) ALL=(ALL) NOPASSWD: $SCRIPT_PATH" | sudo tee /etc/sudoers.d/update_script > /dev/null

# Set the correct permissions
sudo chmod 440 /etc/sudoers.d/update_script

echo "Setup completed! The update script will run every day at $hour:$minute."

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
