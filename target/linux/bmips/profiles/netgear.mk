#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/CVG834G
  NAME:=Netgear CVG834G
  PACKAGES:=
endef
define Profile/CVG834G/Description
  Package set optimized for Netgear CVG834G.
endef
$(eval $(call Profile,CVG834G))
