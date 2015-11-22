#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/smartrg-sr400ac
  NAME:=SmartRG SR400ac
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/smartrg-sr400ac/Description
  Package set optimized for SmartRG SR400ac.
endef
$(eval $(call Profile,smartrg-sr400ac))
