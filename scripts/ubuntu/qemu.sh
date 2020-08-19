#!/bin/bash -eux

# To allow for autmated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

apt-get --assume-yes install qemu-guest-agent

# Boosts the available entropy which allows magma to start faster.
apt-get --assume-yes install haveged

# Autostart the haveged daemon.
systemctl enable haveged.service
