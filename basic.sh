#!/bin/bash

# Set default values
username="user"
password="root"
chrome_remote_desktop_url="https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"

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
sudo apt-get install xfce4 dbus-x11 xfce4-goodies desktop-base xscreensaver -y

# Set up Chrome Remote Desktop session
log "Setting up Chrome Remote Desktop session"
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'

# Disable lightdm service
log "Disabling lightdm service"
sudo systemctl disable lightdm.service

# Install Firefox ESR
sudo apt-get install firefox-esr

log "Installation completed successfully"
