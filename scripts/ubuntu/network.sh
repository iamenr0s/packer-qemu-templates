# Disable IPv6
sysctl net.ipv6.conf.all.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 = 1" | tee -a /etc/sysctl.d/local.conf

# Revert the OS naming of interface names to older ethX formats.
orig="$(head -n1 /boot/firmware/cmdline.txt ) net.ifnames=0 biosdevname=0"
echo $orig | sudo tee /boot/firmware/cmdline.txt

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
