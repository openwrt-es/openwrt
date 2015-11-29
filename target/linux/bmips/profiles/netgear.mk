#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/CG3100D
  NAME:=Netgear CG3100D
  PACKAGES:=
endef
define Profile/CG3100D/Description
  Package set optimized for Netgear CG3100D.
endef
$(eval $(call Profile,CG3100D))

define Profile/CVG834G
  NAME:=Netgear CVG834G
  PACKAGES:=
endef
define Profile/CVG834G/Description
  Package set optimized for Netgear CVG834G.
endef
$(eval $(call Profile,CVG834G))
