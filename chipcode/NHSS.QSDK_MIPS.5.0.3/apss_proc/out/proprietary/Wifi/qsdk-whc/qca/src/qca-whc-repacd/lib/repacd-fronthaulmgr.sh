#!/bin/sh
# Copyright (c) 2017 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.

FRONTHAULMGRMON_DEBUG_OUTOUT=0

. /lib/functions/repacd-gwmon.sh
. /lib/functions/repacd-wifimon.sh
. /lib/functions/whc-network.sh

is_front_haul_VAPs_brought_down=0

# Config Parameters
Manage_front_and_back_hauls_independent=0
fronthaul_VAPs_bringdown_time=0

# Local parameters
ap_ifaces_24g= ap_ifaces_5g=

# Emit a message at debug level.
# input: $1 - the message to log
__repacd_fronthaulmgrmon_debug() {
    local stderr=''
    if [ "$BACKHAULMGRMON_DEBUG_OUTOUT" -gt 0 ]; then
        stderr='-s'
    fi

    logger $stderr -t repacd.fronthaulmgrmon -p user.debug "$1"
}

# Emit a message at info level.
__repacd_fronthaulmgrmon_info() {
    local stderr=''
    if [ "$BACKHAULMGRMON_DEBUG_OUTOUT" -gt 0 ]; then
        stderr='-s'
    fi

    logger $stderr -t repacd.fronthaulmgrmon -p user.info "$1"
}

__repacd_fronthaulmgrmon_get_fronthaul_vaps() {
    local config="$1"
    local network_to_match="$2"
    local iface disabled mode bssid device hwmode

    config_get network "$config" network
    config_get iface "$config" ifname
    config_get disabled "$config" disabled '0'
    config_get mode "$config" mode
    config_get bssid "$config" bssid
    config_get device "$config" device
    config_get hwmode "$device" hwmode

    if [ "$hwmode" != "11ad" ]; then
        if [ "$network" = $network_to_match -a -n "$iface" -a "$mode" = "ap" \
            -a "$disabled" -eq 0 ]; then

            if whc_is_5g_vap $config; then
                __repacd_fronthaulmgrmon_debug "5 GHz AP VAP ($iface) found"
                if [ -z "${ap_ifaces_5g}" ]; then
                    ap_ifaces_5g="$iface"
                else
                    ap_ifaces_5g="$ap_ifaces_5g $iface"
                fi
            else
                __repacd_fronthaulmgrmon_debug "2.4 GHz AP VAP ($iface) found"
                if [ -z "${ap_ifaces_24g}" ]; then
                    ap_ifaces_24g="$iface"
                else
                    ap_ifaces_24g="$ap_ifaces_24g $iface"
                fi
            fi
        fi
    fi
}

__repacd_fronthaulmgrmon_bringup_AP_VAPs() {
    if [ -z "${ap_ifaces_5g}" ]; then
        __repacd_fronthaulmgrmon_debug "No 5 GHz AP VAPs found"
    else
        # Bring Up all 5G AP VAPs
        for item in $ap_ifaces_5g
        do
            ifconfig $item up
        done
    fi

    if [ -z "${ap_ifaces_24g}" ]; then
        __repacd_fronthaulmgrmon_debug "No 2.4 GHz AP VAPs found"
    else
        # Bring Up all 2.4G AP VAPs
        for item in $ap_ifaces_24g
        do
            ifconfig $item up
        done
    fi
}

__repacd_fronthaulmgrmon_bringdown_AP_VAPs() {
    if [ -z "${ap_ifaces_5g}" ]; then
        __repacd_fronthaulmgrmon_debug "No 5 GHz AP VAPs found"
    else
        # Bring Down all 5G AP VAPs
        for item in $ap_ifaces_5g
        do
            ifconfig $item down
        done
    fi

    if [ -z "${ap_ifaces_24g}" ]; then
        __repacd_fronthaulmgrmon_debug "No 2.4 GHz AP VAPs found"
    else
        # Bring Down all 2.4G AP VAPs
        for item in $ap_ifaces_24g
        do
            ifconfig $item down
        done
    fi
}

repacd_fronthaulmgrmon_init() {
    # First resolve the config parameters.
    config_load repacd
    config_get Manage_front_and_back_hauls_independent 'FrontHaulMgr' 'ManageFrontAndBackHaulsIndependently' '0'
    config_get fronthaul_VAPs_bringdown_time 'FrontHaulMgr' 'FrontHaulMgrTimeout' '300'

    if [ "$Manage_front_and_back_hauls_independent" -gt 0 ]; then
        config_load wireless
        config_foreach __repacd_fronthaulmgrmon_get_fronthaul_vaps wifi-iface "lan"

        if [ "$is_gw_reachable" -gt 0 ]; then
            __repacd_fronthaulmgrmon_debug "Bringing up Front-haul VAPs"
            __repacd_fronthaulmgrmon_bringup_AP_VAPs
            is_front_haul_VAPs_brought_down=0
        fi
    fi
}

repacd_fronthaulmgrmon_check() {
    if [ "$Manage_front_and_back_hauls_independent" -gt 0 ]; then
        if [ "$is_gw_reachable" -eq 0 ]; then
            if [ "$is_front_haul_VAPs_brought_down" -eq 0 ]; then
                if  __repacd_wifimon_is_timeout $gw_not_reachable_timestamp $fronthaul_VAPs_bringdown_time; then
                    __repacd_fronthaulmgrmon_debug "Expired $fronthaul_VAPs_bringdown_time sec, Bringing down Front-haul VAPs"
                    __repacd_fronthaulmgrmon_bringdown_AP_VAPs
                    is_front_haul_VAPs_brought_down=1
                fi
            fi
        else
            if [ "$is_front_haul_VAPs_brought_down" -gt 0 ]; then
                __repacd_fronthaulmgrmon_debug "Bringing up Front-haul VAPs"
                __repacd_fronthaulmgrmon_bringup_AP_VAPs
                is_front_haul_VAPs_brought_down=0
            fi
        fi
    fi
}
