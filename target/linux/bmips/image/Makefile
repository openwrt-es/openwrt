#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

LOADADDR = 0x80010000		# RAM start + 64K
KERNEL_ENTRY = $(LOADADDR)	# Newer kernels add a jmp to the kernel_entry at the start of the binary
LOADER_ENTRY = 0x80a00000	# RAM start + 10M, for relocate
RAMSIZE = 0x02000000		# 32MB
LZMA_TEXT_START = 0x81800000	# 32MB - 8MB

LOADER_MAKEOPTS= \
		KDIR=$(KDIR) \
		LOADADDR=$(LOADADDR) \
		KERNEL_ENTRY=$(KERNEL_ENTRY) \
		RAMSIZE=$(RAMSIZE) \
		LZMA_TEXT_START=$(LZMA_TEXT_START) \

RELOCATE_MAKEOPTS= \
		CACHELINE_SIZE=16 \
		KERNEL_ADDR=$(KERNEL_ENTRY) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		LZMA_TEXT_START=$(LOADER_ENTRY)

define Build/Compile
	rm -rf $(KDIR)/relocate
	$(CP) ../../generic/image/relocate $(KDIR)
	$(MAKE) -C $(KDIR)/relocate $(RELOCATE_MAKEOPTS)
endef

### Kernel scripts ###
define Build/append-dtb
	$(call Image/BuildDTB,../dts/$(DEVICE_DTS).dts,$@.dtb)
	cat $@.dtb >> $@
endef

define Build/gzip
	gzip -9 -c $@ > $@.gz
	mv $@.gz $@
endef

define Build/hcs-initramfs
	$(STAGING_DIR_HOST)/bin/hcsmakeimage --magic_bytes=$(HCS_MAGIC_BYTES) \
		--rev_maj=$(HCS_REV_MAJ) --rev_min=$(HCS_REV_MIN) --input_file=$@ \
		--output_file=$@.hcs --ldaddress=$(LOADADDR)
	mv $@.hcs $@
endef

define Build/loader-lzma
	rm -rf $@.src
	$(MAKE) -C lzma-loader \
		$(LOADER_MAKEOPTS) \
		PKG_BUILD_DIR="$@.src" \
		TARGET_DIR="$(dir $@)" \
		LOADER_DATA="$@" \
		LOADER_NAME="$(notdir $@)" \
		compile loader.$(1)
	mv "$@.$(1)" "$@"
	rm -rf $@.src
endef

define Build/lzma
	# CFE is a LZMA nazi! It took me hours to find out the parameters!
	# Also I think lzma has a bug cause it generates different output depending on
	# if you use stdin / stdout or not. Use files instead of stdio here, cause
	# otherwise CFE will complain and not boot the image.
	$(STAGING_DIR_HOST)/bin/lzma e $@ -d22 -fb64 -a1 $@.lzma
	mv $@.lzma $@
endef

define Build/lzma-cfe
	# Strip out the length, CFE doesn't like this
	dd if=$@ of=$@.lzma.cfe bs=5 count=1
	dd if=$@ of=$@.lzma.cfe ibs=13 obs=5 skip=1 seek=1 conv=notrunc
	mv $@.lzma.cfe $@
endef

define Build/relocate-kernel
	# CFE only allows ~4 MiB for the uncompressed kernels, but uncompressed
	# kernel might get larger than that, so let CFE unpack and load at a
	# higher address and make the kernel relocate itself to the expected
	# location.
	( \
		dd if=$(KDIR)/relocate/loader.bin bs=32 conv=sync && \
		perl -e '@s = stat("$@"); print pack("N", @s[7])' && \
		cat $@ \
	) > $@.relocate
	mv $@.relocate $@
endef

### Image scripts ###
define rootfspad/jffs2-128k
--align-rootfs
endef
define rootfspad/jffs2-64k
--align-rootfs
endef
define rootfspad/squashfs
endef

define Image/LimitName16
$(shell expr substr "$(1)" 1 16)
endef

define Image/FileSystemStrip
$(subst root.,,$(notdir $(1)))
endef

define Build/cfe-bin
	$(STAGING_DIR_HOST)/bin/imagetag -i $(word 1,$^) -f $(word 2,$^) \
		--output $@ --boardid $(CFE_BOARD_ID) --chipid $(CFE_CHIP_ID) \
		--entry $(LOADER_ENTRY) --load-addr $(LOADER_ENTRY) \
		--info1 "$(call Image/LimitName16,$(DEVICE_NAME))" \
		--info2 "$(call Image/FileSystemStrip,$(word 2,$^))" \
		$(call rootfspad/$(call Image/FileSystemStrip,$(word 2,$^))) \
		$(CFE_EXTRAS) $(1)
endef

# Shared device definition: applies to every defined device
define Device/Default
  PROFILES = Default $$(DEVICE_PROFILE)
  KERNEL_INITRAMFS_IMAGE = $$(KERNEL_INITRAMFS_PREFIX).elf
  DEVICE_PROFILE :=
  DEVICE_NAME :=
  DEVICE_DTS :=
endef
DEVICE_VARS += DEVICE_PROFILE DEVICE_NAME DEVICE_DTS

# BCM33xx HCS devices: only generates ramdisks (unsupported bin images)
define Device/bcm33xxHcsRamdisk
# KERNEL_INITRAMFS := kernel-bin | append-dtb | lzma | loader-lzma bin | hcs-initramfs
  KERNEL_INITRAMFS := kernel-bin | append-dtb | hcs-initramfs
  IMAGES :=
  HCS_MAGIC_BYTES :=
  HCS_REV_MIN :=
  HCS_REV_MAJ :=
endef
DEVICE_VARS += HCS_MAGIC_BYTES HCS_REV_MIN HCS_REV_MAJ

# Shared BCM63xx CFE device definitios
define Device/bcm63xxCfeCommon
  FILESYSTEMS := squashfs jffs2-64k jffs2-128k
  KERNEL := kernel-bin | append-dtb | relocate-kernel | lzma | lzma-cfe
  KERNEL_INITRAMFS := kernel-bin | append-dtb | lzma | loader-lzma elf
endef

# BCM63xx CFE devices: only generates ramdisks (unsupported bin images)
define Device/bcm63xxCfeRamdisk
  $(Device/bcm63xxCfeCommon)
  IMAGES :=
endef

# BCM63xx CFE devices: both ramdisks and parallel/spi bin images
# New versions of CFE bootloader compatible with imagetag
define Device/bcm63xxCfe
  $(Device/bcm63xxCfeCommon)
  IMAGES := cfe.bin
  IMAGE/cfe.bin := cfe-bin
  CFE_BOARD_ID :=
  CFE_CHIP_ID :=
  CFE_EXTRAS :=
endef
DEVICE_VARS += CFE_BOARD_ID CFE_CHIP_ID CFE_EXTRAS

# $(2) = image name
# $(3) = dts
# $(4) = hcs magic bytes
# $(5) = hcs rev min
# $(6) = hcs rev major
define bcm33xxHcsRamdisk
  define Device/$(2)
    $$(Device/bcm33xxHcsRamdisk)
    DEVICE_PROFILE := $(1)
    DEVICE_NAME := $(2)
    DEVICE_DTS := $(3)
    HCS_MAGIC_BYTES := $(4)
    HCS_REV_MIN := $(5)
    HCS_REV_MAJ := $(6)
  endef
  TARGET_DEVICES += $(2)
endef

# $(1) = profile
# $(2) = image name
# $(3) = dts
define bcm63xxCfeRamdisk
  define Device/$(2)
    $$(Device/bcm63xxCfeRamdisk)
    DEVICE_PROFILE := $(1)
    DEVICE_NAME := $(2)
    DEVICE_DTS := $(3)
  endef
  TARGET_DEVICES += $(2)
endef

# $(1) = profile
# $(2) = image name
# $(3) = dts
# $(4) = cfe board name
# $(5) = cfe chip id
# $(6) = cfe additional options
define bcm63xxCfe
  define Device/$(2)
    $$(Device/bcm63xxCfe)
    DEVICE_PROFILE := $(1)
    DEVICE_NAME := $(2)
    DEVICE_DTS := $(3)
    CFE_BOARD_ID := $(4)
    CFE_CHIP_ID := $(5)
    CFE_EXTRAS := $(6)
  endef
  TARGET_DEVICES += $(2)
endef

### Devices ###
# Comtrend AR-5381u
$(eval $(call bcm63xxCfe,AR5381u,AR-5381u,ar-5381u,96328A-1241N,6328,--pad 8))
# Comtrend AR-5387un
$(eval $(call bcm63xxCfe,AR5387un,AR-5387un,ar-5387un,96328A-1441N1,6328,--pad 8))
# Comtrend VG-8050
$(eval $(call bcm63xxCfeRamdisk,VG8050,VG-8050,vg-8050,963169P-1861N5,63268))
# Comtrend VR-3025u
$(eval $(call bcm63xxCfe,VR3025u,VR-3025u,vr-3025u,96368M-1541N,6368,--pad 16 --image-offset 0x20000 --block-size 0x20000))
# Comtrend VR-3025un
$(eval $(call bcm63xxCfe,VR3025un,VR-3025un,vr-3025un,96368M-1341N,6368,--pad 4))
# Comtrend VR-3032u
$(eval $(call bcm63xxCfeRamdisk,VR3032u,VR-3032u,vr-3032u,963168M-1841N1,63268))
# Comtrend WAP-5813n
$(eval $(call bcm63xxCfe,WAP5813n,WAP-5813n,wap-5813n,96369R-1231N,6368,--pad 4))
# Huawei HG520v
$(eval $(call bcm63xxCfe,HG520v,HG520v,hg520v,HW6358GW_B,6358,--rsa-signature "EchoLife_HG520v"))
# Huawei HG556a
$(eval $(call bcm63xxCfe,HG556a_AB,HG556a_A,hg556a-a,HW556,6358,--rsa-signature "EchoLife_HG556a" --image-offset 0x20000 --block-size 0x10000 --tag-version 8))
$(eval $(call bcm63xxCfe,HG556a_AB,HG556a_B,hg556a-b,HW556,6358,--rsa-signature "EchoLife_HG556a" --image-offset 0x20000 --block-size 0x20000 --tag-version 8))
$(eval $(call bcm63xxCfe,HG556a_C,HG556a_C,hg556a-c,HW556,6358,--rsa-signature "EchoLife_HG556a" --image-offset 0x20000 --block-size 0x20000 --tag-version 8))
# Netgear CG3100D
$(eval $(call bcm33xxHcsRamdisk,CG3100D,cg3100d,cg3100d,0xa0e7,0003,0000))
# Netgear CVG834G
$(eval $(call bcm33xxHcsRamdisk,CVG834G,cvg834g,cvg834g,0xa020,0001,0022))
# SFR Neufbox 4
$(eval $(call bcm63xxCfe,Neufbox4,NEUFBOX4-SER,nb4-ser-r0,96358VW,6358,--rsa-signature "OpenWRT-$(REVISION)"))
$(eval $(call bcm63xxCfe,Neufbox4,NEUFBOX4-FXC,nb4-fxc-r1,96358VW,6358,--rsa-signature "OpenWRT-$(REVISION)"))
# Sagem F@ST1704
$(eval $(call bcm63xxCfe,FAST1704,F@ST1704,fast1704,F@ST1704,6338))

$(eval $(call BuildImage))
