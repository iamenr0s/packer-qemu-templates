#!/bin/bash -eux

# Disable IPv6
sysctl net.ipv6.conf.all.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 = 1" | tee -a /etc/sysctl.d/local.conf

printf "ubuntu-focal.localdomain\n" > /etc/hostname
printf "\n127.0.0.1 ubuntu-focal.localdomain\n\n" >> /etc/hosts

# Configure network interface
cat <<EOF | tee /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
      optional: true
      nameservers:
        addresses: [208.67.222.222,208.67.220.220]
EOF

netplan generate

# Ensure a nameserver is being used that won't return an IP for non-existent domain names.
sed -i -e "s/#DNS=.*/DNS= 208.67.222.222 208.67.220.220/g" /etc/systemd/resolved.conf
sed -i -e "s/#FallbackDNS=.*/FallbackDNS=/g" /etc/systemd/resolved.conf
sed -i -e "s/#Domains=.*/Domains=/g" /etc/systemd/resolved.conf
sed -i -e "s/#DNSSEC=.*/DNSSEC=yes/g" /etc/systemd/resolved.conf
sed -i -e "s/#Cache=.*/Cache=yes/g" /etc/systemd/resolved.conf
sed -i -e "s/#DNSStubListener=.*/DNSStubListener=yes/g" /etc/systemd/resolved.conf

# Install ifplugd so we can monitor and auto-configure nics.
apt-get --assume-yes install ifplugd

# Configure ifplugd to monitor the eth0 interface.
sed -i -e 's/INTERFACES=.*/INTERFACES="eth0"/g' /etc/default/ifplugd

# Ensure the networking interfaces get configured on boot.
systemctl enable systemd-networkd.service

# Ensure ifplugd also gets started, so the ethernet interface is monitored.
systemctl enable ifplugd.service
