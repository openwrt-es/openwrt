#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/UDOO_NEO
  NAME:=UDOO Neo
  PACKAGES:= \
	kmod-thermal-imx kmod-usb-chipidea-imx kmod-usb-mxs-phy \
	uboot-imx6-udoo_neo
endef

$(eval $(call Profile,UDOO_NEO))
