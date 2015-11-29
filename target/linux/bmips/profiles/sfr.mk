#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/Neufbox4
  NAME:=SFR Neufbox4
  PACKAGES:=
endef
define Profile/Neufbox4/Description
  Package set optimized for Neufbox4.
endef
$(eval $(call Profile,Neufbox4))
