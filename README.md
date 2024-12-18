# debian-autoupdater
A simple sh script that updates the apt repos at 16:30 every day

1. Use ` sudo apt-get update && sudo apt-get -y full-upgrade && sudo apt-get -y install git` to download the file via your linux CLI.

2. Make shure to use chmod +x setup_update_script.sh to make it executable.

3. Run ./setup_update_script.sh to install the script
