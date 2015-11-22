#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/netgear-r6250
  NAME:=NETGEAR R6250
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/netgear-r6250/Description
  Package set optimized for NETGEAR R6250.
endef
$(eval $(call Profile,netgear-r6250))

define Profile/netgear-r6300-v2
  NAME:=NETGEAR R6300 v2
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/netgear-r6300-v2/Description
  Package set optimized for NETGEAR R6300 v2.
endef
$(eval $(call Profile,netgear-r6300-v2))

define Profile/netgear-r7000
  NAME:=NETGEAR R7000
  PACKAGES:=kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/netgear-r7000/Description
  Package set optimized for NETGEAR R7000.
endef
$(eval $(call Profile,netgear-r7000))

define Profile/netgear-r8000
  NAME:=NETGEAR R8000
  PACKAGES:=kmod-brcmfmac wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/netgear-r8000/Description
  Package set optimized for NETGEAR R8000.
endef
$(eval $(call Profile,netgear-r8000))
