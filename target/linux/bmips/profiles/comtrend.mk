#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/AR5381u
  NAME:=Comtrend AR-5381u
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/AR5381u/Description
  Package set optimized for AR-5381u.
endef
$(eval $(call Profile,AR5381u))

define Profile/AR5387un
  NAME:=Comtrend AR-5387un
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/AR5387un/Description
  Package set optimized for AR-5387un.
endef
$(eval $(call Profile,AR5387un))

define Profile/CT5361
  NAME:=Comtrend CT-5361
  PACKAGES:=kmod-usb-ohci
endef
define Profile/CT5361/Description
  Package set optimized for CT-5361.
endef
$(eval $(call Profile,CT5361))

define Profile/VG8050
  NAME:=Comtrend VG-8050
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/VG8050/Description
  Package set optimized for VG-8050.
endef
$(eval $(call Profile,VG8050))

define Profile/VR3025u
  NAME:=Comtrend VR-3025u
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/VR3025u/Description
  Package set optimized for VR-3025u.
endef
$(eval $(call Profile,VR3025u))

define Profile/VR3025un
  NAME:=Comtrend VR-3025un
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/VR3025un/Description
  Package set optimized for VR-3025un.
endef
$(eval $(call Profile,VR3025un))

define Profile/VR3032u
  NAME:=Comtrend VR-3032u
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/VR3032u/Description
  Package set optimized for VR-3032u.
endef
$(eval $(call Profile,VR3032u))

define Profile/WAP5813n
  NAME:=Comtrend WAP-5813n
  PACKAGES:=kmod-usb2 kmod-usb-ohci
endef
define Profile/WAP5813n/Description
  Package set optimized for WAP-5813n.
endef
$(eval $(call Profile,WAP5813n))
