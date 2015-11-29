#!/bin/sh
# Copyright (C) 2015 OpenWrt.org

ifname=""

bmips_detect() {
	local board_name model

	model=$(cat /proc/device-tree/model)
	case "$model" in
	"Comtrend AR-5381u")
		board_name="ar-5381u"
		;;
	"Comtrend AR-5387un")
		board_name="ar-5387un"
		;;
	"Comtrend VG-8050")
		board_name="vg-8050"
		;;
	"Comtrend VR-3025u")
		board_name="vr-3025u"
		;;
	"Comtrend VR-3025un")
		board_name="vr-3025un"
		;;
	"Comtrend VR-3032u")
		board_name="vr-3032u"
		;;
	"Comtrend WAP-5813n")
		board_name="wap-5813n"
		;;
	"Huawei EchoLife HG520v")
		board_name="hg520v"
		;;
	"Huawei EchoLife HG556a (version A)")
		board_name="hg556a-a"
		;;
	"Huawei EchoLife HG556a (version B)")
		board_name="hg556a-b"
		;;
	"Huawei EchoLife HG556a (version C)")
		board_name="hg556a-c"
		;;
	"Netgear CG3100D")
		board_name="cg3100d"
		;;
	"Netgear CVG834G")
		board_name="cvg834g"
		;;
	"SFR Neuf Box 4 (Foxconn)")
		board_name="nb4-fxc"
		;;
	"SFR Neuf Box 4 (Sercomm)")
		board_name="nb4-ser"
		;;
	*)
		board_name="unknown"
		;;
	esac

	[ -e "/tmp/sysinfo" ] || mkdir -p "/tmp/sysinfo"

	echo "$board_name" > /tmp/sysinfo/board_name
	echo "$model" > /tmp/sysinfo/model
}

bmips_board_name() {
	local name

	[ -f /tmp/sysinfo/board_name ] && name=$(cat /tmp/sysinfo/board_name)
	[ -z "$name" ] && name="unknown"

	echo "$name"
}
