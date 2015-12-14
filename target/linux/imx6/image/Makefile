#
# Copyright (C) 2013-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_IMX6_SD_BOOT_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

#################################################
# Images
#################################################

# build a ubi for a specific flash geometry/layout which can contain
# volumes with the following data from ubinize-$(DEVICE_NAME).cfg:
#   - 'boot.ubifs' volume: kernel+dtbs+bootscript
#   - 'root.squashfs' volume: rootfs
# $(1): name (used for suffix)
# $(2): PAGESIZE (-m param to mkfs.ubifs/ubinize)
# $(3): ERASESIZE (logical eraseblock size: -e param to mkfs.ubifs)
# $(4): BLOCKSIZE (-p param to ubinize)
# $(5): MAXSIZE (maximum file-system size in LEB's -c param to mkfs.ubifs)
#
define Build/ubi-boot-overlay
	# ubi-boot-overlay $(DEVICE_NAME) $(word 1, $(1))

	# boot filesystem
	rm -rf $(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))
	mkdir -p $(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))
	$(CP) $< $(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))/$(IMG_PREFIX)-uImage
	ln -sf $(IMG_PREFIX)-uImage \
		$(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))/uImage
	$(foreach dts,$(shell echo $(DEVICE_DTS)), \
		$(CP) $(LINUX_DIR)/arch/$(ARCH)/boot/dts/$(dts).dtb \
			$(BIN_DIR)/$(IMG_PREFIX)-$(dts).dtb; \
		$(CP) $(LINUX_DIR)/arch/$(ARCH)/boot/dts/$(dts).dtb \
			$(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))/$(IMG_PREFIX)-$(dts).dtb; \
		ln -sf $(IMG_PREFIX)-$(dts).dtb \
			$(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))/$(dts).dtb; \
	)
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
		-n '$(DEVICE_ID) OpenWrt bootscript' \
		-d ./bootscript-$(DEVICE_NAME) \
		$(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))/6x_bootscript-$(DEVICE_NAME)
	$(STAGING_DIR_HOST)/bin/mkfs.ubifs \
		--space-fixup --force-compr=zlib --squash-uids \
		-m $(word 2, $(1)) -e $(word 3, $(1)) -c $(word 5, $(1)) \
		-o $(KDIR)/boot-$(DEVICE_NAME)-bootfs_$(word 1, $(1)).ubifs \
		-d $(TARGET_ROOTFS_DIR)/boot-$(DEVICE_NAME)_$(word 1, $(1))
	$(CP) $(KDIR)/boot-$(DEVICE_NAME)-bootfs_$(word 1, $(1)).ubifs \
		$(BIN_DIR)/$(IMG_PREFIX)-$(DEVICE_NAME)-bootfs_$(word 1, $(1)).ubifs

	# ubi
	rm -rf p $(KDIR)/$(DEVICE_NAME)_$(word 1, $(1))
	mkdir -p $(KDIR)/$(DEVICE_NAME)_$(word 1, $(1))
	$(CP) $(word 2, $^) \
		$(KDIR)/$(DEVICE_NAME)_$(word 1, $(1))/
	$(CP) $(KDIR)/boot-$(DEVICE_NAME)-bootfs_$(word 1, $(1)).ubifs \
		$(KDIR)/$(DEVICE_NAME)_$(word 1, $(1))/boot.ubifs
	$(CP) ./ubinize-$(DEVICE_NAME).cfg \
		$(KDIR)/$(DEVICE_NAME)_$(word 1, $(1))/ubinize.cfg
	( cd $(KDIR)/$(DEVICE_NAME)_$(word 1, $(1)); \
		$(STAGING_DIR_HOST)/bin/ubinize \
		-m $(word 2, $(1)) -p $(word 4, $(1)) -s $(word 2, $(1)) \
		-o $@ \
		ubinize.cfg \
	)
endef

# build a SD image with 2 partitions: FAT (bootfs) + EXT4 (rootfs)
define Build/image-sdcard
	# Create bootfs partition
	rm -f $@.boot
	mkfs.fat -C $@.boot $(FAT32_BLOCKS)
	mcopy -i $@.boot $(word 1,$^) ::zImage
	mcopy -i $@.boot $(BIN_DIR)/uboot-$(BOARD)-$(DEVICE_BOOT_NAME)/openwrt-$(BOARD)-$(DEVICE_BOOT_NAME)-u-boot.imx \
		::/uboot-$(DEVICE_BOOT_NAME).imx
	mmd -i $@.boot ::/dts
	$(foreach dts,$(shell echo $(DEVICE_DTS)), \
		$(CP) $(DTS_DIR)/$(dts).dtb \
			$(BIN_DIR)/$(IMG_PREFIX)-$(dts).dtb; \
		mcopy -i $@.boot $(DTS_DIR)/$(dts).dtb ::/dts/; \
	)
	# Generate SD card image
	$(TOPDIR)/target/linux/brcm2708/image/gen_rpi_sdcard_img.sh $@ $@.boot $(word 2,$^) \
		$(CONFIG_IMX6_SD_BOOT_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
	# Write bootloader to image at proper block
	dd if=$(BIN_DIR)/uboot-$(BOARD)-$(DEVICE_BOOT_NAME)/openwrt-$(BOARD)-$(DEVICE_BOOT_NAME)-u-boot.imx \
		of=$@ bs=$(FAT32_BLOCK_SIZE) seek=$(DEVICE_BOOT_BLOCK) conv=notrunc
endef

#################################################
# Devices
#################################################

KERNEL_LOADADDR=0x10008000

define Device/Default
	DEVICE_DTS :=
	FILESYSTEMS := squashfs ext4
	KERNEL_INSTALL := 1
	KERNEL_SUFFIX := -uImage
	KERNEL_NAME := zImage
	KERNEL := kernel-bin | uImage none
	IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
	IMAGES :=
endef

DEVICE_VARS += DEVICE_DTS

define Device/imx6_sd
	FILESYSTEMS := ext4
	KERNEL_SUFFIX := -zImage
	KERNEL := kernel-bin
	IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1)-$$(2)
	IMAGES := sdcard.img
	IMAGE/sdcard.img := image-sdcard
	DEVICE_BOOT_NAME :=
	DEVICE_BOOT_BLOCK :=
endef

DEVICE_VARS += DEVICE_BOOT_NAME DEVICE_BOOT_BLOCK

define Device/udoo_neo
	$(Device/imx6_sd)
	PROFILES = Generic UDOO_NEO
	DEVICE_DTS := \
		imx6sx-udoo-neo-basic \
		imx6sx-udoo-neo-basic-hdmi \
		imx6sx-udoo-neo-basic-hdmi-m4 \
		imx6sx-udoo-neo-basic-lvds15 \
		imx6sx-udoo-neo-basic-lvds15-m4 \
		imx6sx-udoo-neo-basic-lvds7 \
		imx6sx-udoo-neo-basic-lvds7-m4 \
		imx6sx-udoo-neo-basic-m4 \
		imx6sx-udoo-neo-basicks \
		imx6sx-udoo-neo-basicks-hdmi \
		imx6sx-udoo-neo-basicks-hdmi-m4 \
		imx6sx-udoo-neo-basicks-lvds15 \
		imx6sx-udoo-neo-basicks-lvds15-m4 \
		imx6sx-udoo-neo-basicks-lvds7 \
		imx6sx-udoo-neo-basicks-lvds7-m4 \
		imx6sx-udoo-neo-basicks-m4 \
		imx6sx-udoo-neo-extended \
		imx6sx-udoo-neo-extended-hdmi \
		imx6sx-udoo-neo-extended-hdmi-m4 \
		imx6sx-udoo-neo-extended-lvds15 \
		imx6sx-udoo-neo-extended-lvds15-m4 \
		imx6sx-udoo-neo-extended-lvds7 \
		imx6sx-udoo-neo-extended-lvds7-m4 \
		imx6sx-udoo-neo-extended-m4 \
		imx6sx-udoo-neo-full \
		imx6sx-udoo-neo-full-hdmi \
		imx6sx-udoo-neo-full-hdmi-m4 \
		imx6sx-udoo-neo-full-lvds15 \
		imx6sx-udoo-neo-full-lvds15-m4 \
		imx6sx-udoo-neo-full-lvds7 \
		imx6sx-udoo-neo-full-lvds7-m4 \
		imx6sx-udoo-neo-full-m4
	DEVICE_BOOT_NAME := udoo_neo
	DEVICE_BOOT_BLOCK := 1
endef

define Device/ventana
	PROFILES = Generic VENTANA
	DEVICE_DTS:= \
		imx6dl-gw51xx \
		imx6dl-gw52xx \
		imx6dl-gw53xx \
		imx6dl-gw54xx \
		imx6dl-gw551x \
		imx6dl-gw552x \
		imx6q-gw51xx \
		imx6q-gw52xx \
		imx6q-gw53xx \
		imx6q-gw54xx \
		imx6q-gw5400-a \
		imx6q-gw551x \
		imx6q-gw552x
	IMAGES := nand-factory_normal.ubi nand-factory_large.ubi
	IMAGE/nand-factory_normal.ubi := ubi-boot-overlay normal 2048 124KiB 128KiB 8124
	IMAGE/nand-factory_large.ubi := ubi-boot-overlay large 4096 248KiB 256KiB 8124
endef

define Device/wandboard
	PROFILES = Generic IMX6DL_WANDBOARD
	DEVICE_DTS := imx6dl-wandboard
endef

TARGET_DEVICES += \
	udoo_neo \
	ventana \
	wandboard

$(eval $(call BuildImage))
