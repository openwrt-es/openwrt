#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/linksys-ea6300-v1
  NAME:=Linksys EA6300 v1
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/linksys-ea6300-v1/Description
  Package set optimized for Linksys EA6300 v1.
endef
$(eval $(call Profile,linksys-ea6300-v1))
