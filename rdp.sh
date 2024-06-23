#!/bin/bash

# Set default values
username="user"
password="root"
chrome_remote_desktop_url="https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
burp_url="https://portswigger.net/burp/releases/startdownload?product=community&version=2024.5.3&type=Linux"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Installation steps
log "Starting installation"
sudo apt-get update -y

# Create user
log "Creating user '$username'"
sudo useradd -m "$username"
echo "$username:$password" | sudo chpasswd
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd

# Install Chrome Remote Desktop
wget -q --show-progress $chrome_remote_desktop_url
sudo dpkg -i $(basename $chrome_remote_desktop_url)
sudo apt-get install --fix-broken -y

# Install XFCE desktop environment
log "Installing XFCE desktop environment"
sudo apt-get install xfce4 -y

# Set up Chrome Remote Desktop session
log "Setting up Chrome Remote Desktop session"
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'

# Disable lightdm service
log "Disabling lightdm service"
sudo systemctl disable lightdm.service

# Install Firefox ESR
sudo apt install firefox-esr

# Install Burp Suite Community Edition
wget -q --show-progress -O "burp.sh" "$burp_url"
printf "o\n\ny\n\n" | sh burp.sh

log "Installation completed successfully"
