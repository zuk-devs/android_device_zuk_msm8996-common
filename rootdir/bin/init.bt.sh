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

# Set the proper hardware based BT mac address
proc_bt="/proc/mac_bt"
bt_mac_path="/mnt/vendor/persist/bluetooth/bt_mac"
if [[ $(xxd -p $proc_bt) == "000000000000" ]] || [[ $(xxd -p $proc_bt) == "666666666666" ]] || [[ ! -f $proc_bt ]]; then
    ran1=$(xxd -l 1 -p /dev/urandom)
    ran2=$(xxd -l 1 -p /dev/urandom)
    ran3=$(xxd -l 1 -p /dev/urandom)
    ran4=$(xxd -l 1 -p /dev/urandom)
    ran5=$(xxd -l 1 -p /dev/urandom)
    ran6=$(xxd -l 1 -p /dev/urandom)

    bt_mac=$(echo "$ran1$ran2$ran3$ran4$ran5$ran6" | tr '[:lower:]' '[:upper:]' | sed 's/.\{2\}/&:/g' | sed 's/.$//');
else
    bt_mac=$(xxd -p $proc_bt | tr '[:lower:]' '[:upper:]' | sed 's/.\{2\}/&:/g' | sed 's/.$//');
fi;

if [[ ! -f $bt_mac_path ]] || [[ $(cat $bt_mac_path) == "" ]] || [[ $(cat $bt_mac_path) == "000000000000" ]] || [[ $(cat $bt_mac_path) == "666666666666" ]]; then
    echo $bt_mac > $bt_mac_path
fi;
