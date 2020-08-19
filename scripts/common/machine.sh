#!/bin/bash -eux

if [ -f /etc/machine-id ]; then
  truncate --size=0 /etc/machine-id
fi

if [ -f /run/machine-id ]; then
  truncate --size=0 /run/machine-id
fi