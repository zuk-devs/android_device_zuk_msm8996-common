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
bt_mac_path="/data/vendor/bluetooth/bdaddr"
bt_mac=$(getprop sys.bt.address);
if [[ ! -f $bt_mac_path ]] || [[ $(echo $bt_mac) != $(cat /data/vendor/bluetooth/bdaddr) ]]; then
    echo $bt_mac > $bt_mac_path
fi;
setprop ro.vendor.bt.bdaddr_path $bt_mac_path
