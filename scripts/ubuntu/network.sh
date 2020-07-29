# Disable IPv6
sysctl net.ipv6.conf.all.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 = 1" | tee -a /etc/sysctl.d/local.conf

# Revert the OS naming of interface names to older ethX formats.
sed -ie 's/\(^GRUB_CMDLINE_LINUX="\)/\1net.ifnames=0 biosdevname=0/' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

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
