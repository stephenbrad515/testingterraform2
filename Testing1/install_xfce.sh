#!/bin/bash
set -e

# Define the flag file location if this files exists script will not run
FLAG_FILE="/etc/startup_was_launched_for_XFCE"

# Check if the flag file exists
if [ -f "$FLAG_FILE" ]; then
  echo "Startup script has already run. Exiting."
  exit 0
fi

# Update and install dependencies
sudo apt-get update

#Install Chrome Remote Desktop on the VM instance
curl https://dl.google.com/linux/linux_signing_key.pub \
    | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/chrome-remote-desktop.gpg
echo "deb [arch=amd64] https://dl.google.com/linux/chrome-remote-desktop/deb stable main" \
    | sudo tee /etc/apt/sources.list.d/chrome-remote-desktop.list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive \
    apt-get install --assume-yes chrome-remote-desktop

#Install an X Windows System desktop environment XFCE
sudo DEBIAN_FRONTEND=noninteractive \
    apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver


#Configure Chrome Remote Desktop to use Xfce by default
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'

#Because there is no display connected to your instance, disable the display manager service on your instance
sudo systemctl disable lightdm.service

#Install the full suite of Linux desktop applications along with the Xfce desktop
sudo apt install --assume-yes task-xfce-desktop

#Install the Chrome browser
curl -L -o google-chrome-stable_current_amd64.deb \
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes --fix-broken ./google-chrome-stable_current_amd64.deb



# Create the flag file to mark the script as executed
sudo touch "$FLAG_FILE"
echo "One-time setup complete and flag file created."