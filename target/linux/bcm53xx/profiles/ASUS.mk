#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/asus-rt-ac56u
  NAME:=ASUS RT-AC56U
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/asus-rt-ac56u/Description
  Package set optimized for ASUS RT-AC56U.
endef
$(eval $(call Profile,asus-rt-ac56u))

define Profile/asus-rt-ac68u
  NAME:=ASUS RT-AC68U
  PACKAGES:=kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/asus-rt-ac68u/Description
  Package set optimized for ASUS RT-AC68U.
endef
$(eval $(call Profile,asus-rt-ac68u))

define Profile/asus-rt-ac87u
  NAME:=ASUS RT-AC87U
  PACKAGES:=kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/asus-rt-ac87u/Description
  Package set optimized for ASUS RT-AC87U.
endef
$(eval $(call Profile,asus-rt-ac87u))

define Profile/asus-rt-n18u
  NAME:=ASUS RT-N18U
  PACKAGES:=kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/asus-rt-n18u/Description
  Package set optimized for ASUS RT-N18U.
endef
$(eval $(call Profile,asus-rt-n18u))
