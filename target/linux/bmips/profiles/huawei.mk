#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/HG520v
  NAME:=Huawei EchoLife HG520v
  PACKAGES:=
endef
define Profile/HG520v/Description
  Package set optimized for Huawei HG520v.
endef
$(eval $(call Profile,HG520v))

define Profile/HG556a_AB
  NAME:=Huawei EchoLife HG556a (version A/B - Atheros)
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/HG556a_AB/Description
  Package set optimized for Huawei HG556a version A/B (Atheros).
endef
$(eval $(call Profile,HG556a_AB))

define Profile/HG556a_C
  NAME:=Huawei EchoLife HG556a (version C - Ralink)
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/HG556a_C/Description
  Package set optimized for Huawei HG556a version C (Ralink).
endef
$(eval $(call Profile,HG556a_C))
