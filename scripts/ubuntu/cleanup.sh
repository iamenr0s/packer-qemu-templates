#!/bin/bash -eux

# To allow for autmated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

# Keep the daily apt updater from deadlocking our installs.
systemctl stop apt-daily.service apt-daily.timer
systemctl stop snapd.service snapd.socket snapd.refresh.timer

# Cleanup unused packages.
apt-get --assume-yes autoremove
apt-get --assume-yes autoclean

# Clear the random seed and all lease files.
rm -f /var/lib/systemd/random-seed
