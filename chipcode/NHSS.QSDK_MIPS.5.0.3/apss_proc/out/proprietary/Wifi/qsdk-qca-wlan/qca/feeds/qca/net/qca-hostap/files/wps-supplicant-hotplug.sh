#
# Copyright (c) 2017 Qualcomm Technologies, Inc.
#
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#

#
# Copyright (c) 2014, The Linux Foundation. All rights reserved.
#

pid=
if [ "$ACTION" = "pressed" -a "$BUTTON" = "wps" ]; then
    [ -r /var/run/son_active ] && exit 0
	if [ -r /var/run/wifi-wps-enhc-extn.conf ] &&
		[ ! -r /var/run/son.conf ]; then
		exit 0
	fi
	for dir in /var/run/wpa_supplicant-*; do
		[ -d "$dir" ] || continue
		pid=/var/run/wps-hotplug-${dir#"/var/run/wpa_supplicant-"}.pid
		wpa_cli -p "$dir" wps_pbc
		[ -f $pid ] || {
			wpa_cli -p"$dir" -a/lib/wifi/wps-supplicant-update-uci -P$pid -B
		}
	done
fi
