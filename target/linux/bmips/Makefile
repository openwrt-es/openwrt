#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=bmips
BOARDNAME:=Broadcom Generic BMIPS
FEATURES:=squashfs usb atm pci pcmcia usbgadget
KERNEL_PATCHVER:=4.3
CPU_TYPE:=mips32

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += swconfig kmod-input-gpio-keys-polled kmod-button-hotplug

define Target/Description
	Build firmware images for BCM33xx cable modem chips,
	BCM63xx DSL chips, and BCM7xxx set-top box chips.
endef

$(eval $(call BuildTarget))
