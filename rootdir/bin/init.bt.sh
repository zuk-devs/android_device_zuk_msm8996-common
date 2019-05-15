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
bt_mac=$(xxd -p /proc/mac_bt | tr '[:lower:]' '[:upper:]' | sed 's/.\{2\}/&:/g' | sed 's/.$//');
bt_mac_path="/data/vendor/bluetooth/bdaddr"
if [[ ! -f $bt_mac_path ]] || [[ $(echo $bt_mac) != $(cat $bt_mac_path) ]]; then
    echo $bt_mac > $bt_mac_path
    chmod 0644 $bt_mac_path
    chown bluetooth $bt_mac_path
    chgrp bluetooth $bt_mac_path
fi;
