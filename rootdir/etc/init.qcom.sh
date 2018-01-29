#! /vendor/bin/sh

# Copyright (c) 2009-2016, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_defrtr

#Loop through the sysfs nodes and determine the correct sysfs to change the permission and ownership.
for count in 0 1 2 3 4 5 6 7 8 9 10
do
        dir="/sys/devices/soc/75ba000.i2c/i2c-12/12-0020/input/input"$count
        if [ -d "$dir" ]; then
             chmod 0660 $dir/secure_touch_enable
             chmod 0440 $dir/secure_touch
             chown system.drmrpc $dir/secure_touch_enable
             chown system.drmrpc $dir/secure_touch
             break
        fi
done

#
# Make modem config folder and copy firmware config to that folder for RIL
#
if [ -f /data/vendor/radio/ver_info.txt ]; then
    prev_version_info=`cat /data/vendor/radio/ver_info.txt`
else
    prev_version_info=""
fi

cur_version_info=`cat /firmware/verinfo/ver_info.txt`
if [ ! -f /firmware/verinfo/ver_info.txt -o "$prev_version_info" != "$cur_version_info" ]; then
    rm -rf /data/vendor/radio/modem_config
    mkdir /data/vendor/radio/modem_config
    chmod 770 /data/vendor/radio/modem_config
#[Begin][ZUKMT-164][renrm1][20171020] Modify default mbn location
    #cp -r /firmware/image/modem_pr/mcfg/configs/* /data/vendor/radio/modem_config
    cp -r /firmware/image/modem_pr/mcfg/fancy_co/* /data/vendor/radio/modem_config
#[End][ZUKMT-164][renrm1][20171020] Modify default mbn location
    chown -hR radio.radio /data/vendor/radio/modem_config
    cp /firmware/verinfo/ver_info.txt /data/vendor/radio/ver_info.txt
    chown radio.radio /data/vendor/radio/ver_info.txt
fi
cp /firmware/image/modem_pr/mbn_ota.txt /data/vendor/radio/modem_config
chown radio.radio /data/vendor/radio/modem_config/mbn_ota.txt
echo 1 > /data/vendor/radio/copy_complete
