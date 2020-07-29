# Disable IPv6 for the current boot.
sysctl net.ipv6.conf.all.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6 = 1" | tee -a /etc/sysctl.d/local.conf

cat <<EOF | tee -a /etc/netplan/01-netcfg.yaml
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

# Apply the network plan configuration.
netplan generate
