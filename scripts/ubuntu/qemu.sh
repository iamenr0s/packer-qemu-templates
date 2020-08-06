# To allow for autmated installs, we disable interactive configuration steps.
export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true

retry apt-get --assume-yes install qemu-guest-agent; error

# Boosts the available entropy which allows magma to start faster.
retry apt-get --assume-yes install haveged; error

# Autostart the haveged daemon.
systemctl enable haveged.service
