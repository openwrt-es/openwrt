#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/FAST1704
  NAME:=Sagem F@ST1704
  PACKAGES:=
endef
define Profile/FAST1704/Description
  Package set optimized for Sagem F@ST1704.
endef
$(eval $(call Profile,FAST1704))
