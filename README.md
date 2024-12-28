# debian-autoupdater
A simple sh script that updates the apt repos at 16:30 every day

1. Run `sudo apt install curl -y`.

2. Run `sudo rm -f /tmp/setup_update_script.sh && sudo curl -sSL https://raw.githubusercontent.com/Flavio-coding/debian-autoupdater/main/setup_update_script.sh -o /tmp/setup_update_script.sh && sudo bash /tmp/setup_update_script.sh` to start the installation script.

3. Consider improving this project!
