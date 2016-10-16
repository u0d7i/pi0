#!/bin/bash

# cfg

BASE="/sys/kernel/config/usb_gadget"
GD="${BASE}/cmp"

usb_idVendor="0x1d6b" # Linux Foundation
usb_idProduct="0x0104" # Multifunction Composite Gadget
usb_bcdDevice="0x0100" # v1.0.0
usb_bcdUSB="0x0200" # USB2
usb_serialnr="000000"
usb_manufacturer="Acme"
usb_product="USB Device"


test -d ${BASE} || exit

# common
mkdir -p ${GD}/{strings/0x409,configs/c.1/strings/0x409}
echo ${usb_idVendor}  > ${GD}/idVendor
echo ${usb_idProduct} > ${GD}/idProduct
echo ${usb_bcdDevice} > ${GD}/bcdDevice
echo ${usb_bcdUSB}    > ${GD}/bcdUSB

echo ${usb_serialnr} > ${GD}/strings/0x409/serialnumber
echo ${usb_manufacturer} > ${GD}/strings/0x409/manufacturer
echo ${usb_product} > ${GD}/strings/0x409/product
echo "Config 1: ECM network" > ${GD}/configs/c.1/strings/0x409/configuration
echo 250 > ${GD}/configs/c.1/MaxPower

# Add functions here

# serial
mkdir -p  ${GD}/functions/acm.usb0
ln -s  ${GD}/functions/acm.usb0  ${GD}/configs/c.1/

# ethernet
mkdir -p ${GD}/functions/ecm.usb0
# override random MAC if needed
# first byte of address must be even
#HOST="48:6f:73:74:50:43" # "HostPC"
#SELF="42:61:64:55:53:42" # "BadUSB"
#echo $HOST > ${GD}/functions/ecm.usb0/host_addr
#echo $SELF > ${GD}/functions/ecm.usb0/dev_addr
ln -s ${GD}/functions/ecm.usb0 ${GD}/configs/c.1/

# End functions
ls /sys/class/udc > ${GD}/UDC
