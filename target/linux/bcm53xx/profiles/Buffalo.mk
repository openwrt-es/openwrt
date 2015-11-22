#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/buffalo-wzr-600dhp2
  NAME:=Buffalo WZR-600DHP2
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2
endef
define Profile/buffalo-wzr-600dhp2/Description
  Package set optimized for Buffalo WZR-600DHP2.
endef
$(eval $(call Profile,buffalo-wzr-600dhp2))

define Profile/buffalo-wzr-900dhp
  NAME:=Buffalo WZR-900DHP
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/buffalo-wzr-900dhp/Description
  Package set optimized for Buffalo WZR-900DHP.
endef
$(eval $(call Profile,buffalo-wzr-900dhp))

define Profile/buffalo-wzr-1750dhp
  NAME:=Buffalo WZR-1750DHP
  PACKAGES:=kmod-b43 wpad-mini \
	kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/buffalo-wzr-1750dhp/Description
  Package set optimized for Buffalo WZR-1750DHP.
endef
$(eval $(call Profile,buffalo-wzr-1750dhp))

define Profile/buffalo-wxr-1900dhp
  NAME:=Buffalo WXR-1900DHP
  PACKAGES:=kmod-usb-ohci kmod-usb2 kmod-usb3
endef
define Profile/buffalo-wxr-1900dhp/Description
  Package set optimized for Buffalo WXR-1900DHP.
endef
$(eval $(call Profile,buffalo-wxr-1900dhp))
