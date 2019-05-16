#! /vendor/bin/sh

#
# Copyright (C) 2019 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set the proper hardware based wlan mac
proc_wifi="/proc/mac_wifi"
wifi_mac_persist=$(cat /persist/wlan_mac.bin | grep Intf0MacAddress | sed 's/Intf0MacAddress=//')
if [[ $(xxd -p $proc_wifi) == "000000000000" ]] || [[ $(xxd -p $proc_wifi) == "555555555555" ]] || [[ ! -f $proc_wifi ]]; then
    ran1=$(xxd -l 1 -p /dev/urandom)
    ran2=$(xxd -l 1 -p /dev/urandom)
    ran3=$(xxd -l 1 -p /dev/urandom)
    ran4=$(xxd -l 1 -p /dev/urandom)
    ran5=$(xxd -l 1 -p /dev/urandom)
    ran6=$(xxd -l 1 -p /dev/urandom)

    wifi_mac=$(echo "$ran1$ran2$ran3$ran4$ran5$ran6" | tr '[:lower:]' '[:upper:]')
else
    wifi_mac=$(xxd -p $proc_wifi | tr '[:lower:]' '[:upper:]');
fi;
if [[ ! -f /persist/wlan_mac.bin ]] || [[ $(echo $wifi_mac_persist) == "000000000000" ]] || [[ $(echo $wifi_mac_persist) == "555555555555" ]]; then
    echo "Intf0MacAddress=$wifi_mac" > /persist/wlan_mac.bin
    echo "END" >> /persist/wlan_mac.bin
fi;
