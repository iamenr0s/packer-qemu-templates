#!/bin/bash -eux

export DEBIAN_FRONTEND="noninteractive"

# Update the box
apt-get update -qq > /dev/null
apt-get dist-upgrade -qq -y > /dev/null

# Disable unattended-upgrades
cat <<EOF | tee /lib/systemd/system/apt-daily.timer
[Unit]
Description=Daily apt download activities

[Timer]
Persistent=false

[Install]
WantedBy=timers.target
EOF
