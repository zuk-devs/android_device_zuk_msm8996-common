#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
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

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..

HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "$1" != "" ]; do
    case $1 in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC=$1
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

# Initialize the helper for common device
setup_vendor "$DEVICE_COMMON" "$VENDOR" "$LINEAGE_ROOT" true "$CLEAN_VENDOR"

extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"

if [ -s "$MY_DIR"/../$DEVICE/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false "$CLEAN_VENDOR"

    extract "$MY_DIR"/../$DEVICE/proprietary-files.txt "$SRC" "$SECTION"
fi

BLOB_ROOT="$LINEAGE_ROOT"/vendor/"$VENDOR"/msm8996-common/proprietary

# Patch blobs for VNDK
sed -i "s|libgui.so|libfui.so|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_ppeiscore.so
sed -i "s|libgui.so|libfui.so|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_stats_modules.so
patchelf --remove-needed libandroid.so "$BLOB_ROOT"/vendor/lib/libmmcamera2_stats_modules.so
patchelf --remove-needed libandroid.so "$BLOB_ROOT"/vendor/lib/libmpbase.so

# Hex edit libaudcal.so to store acdbdata in new path
sed -i "s|/data/vendor/misc/audio/acdbdata/delta/|/data/vendor/audio/acdbdata/delta/\x00\x00\x00\x00\x00|g" "$BLOB_ROOT"/vendor/lib/libaudcal.so
sed -i "s|/data/vendor/misc/audio/acdbdata/delta/|/data/vendor/audio/acdbdata/delta/\x00\x00\x00\x00\x00|g" "$BLOB_ROOT"/vendor/lib64/libaudcal.so

# Hex edit /firmware/image to /vendor/firmware_mnt to delete the outdated rootdir symlinks
sed -i "s|/firmware/image|/vendor/f/image|g" "$BLOB_ROOT"/vendor/lib/hw/keystore.msm8996.so
sed -i "s|/firmware/image|/vendor/f/image|g" "$BLOB_ROOT"/vendor/lib/hw/gatekeeper.msm8996.so
sed -i "s|/firmware/image|/vendor/f/image|g" "$BLOB_ROOT"/vendor/lib64/hw/fingerprint.qcom.so
sed -i "s|/firmware/image|/vendor/f/image|g" "$BLOB_ROOT"/vendor/lib64/hw/keystore.msm8996.so
sed -i "s|/firmware/image|/vendor/f/image|g" "$BLOB_ROOT"/vendor/lib64/hw/gatekeeper.msm8996.so
sed -i "s|/firmware/image|/vendor/f/image|g" "$BLOB_ROOT"/vendor/lib64/libSecureUILib.so

# Hex edit /bt_firmware to /vendor/btfw to delete the outdated rootdir symlinks
sed -i "s|/bt_firmware|/vendor/btfw|g" "$BLOB_ROOT"/vendor/lib64/hw/android.hardware.bluetooth@1.0-impl-qti.so

# Hex edit camera blobs to use /data/vendor/qcam
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/bin/mm-qcamera-daemon
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmm-qcamera.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_cpp_module.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_iface_modules.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_imglib_modules.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_mct.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_pproc_modules.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_sensor_modules.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_stats_algorithm.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera2_stats_modules.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_dbg.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_hvx_grid_sum.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_hvx_zzHDR.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_imglib.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_isp_mesh_rolloff44.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_pdaf.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_pdafcamif.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_tintless_algo.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_tintless_bg_pca_algo.so
sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "$BLOB_ROOT"/vendor/lib/libmmcamera_tuning.so

sed -i "s|/data/vendor/camera/cam_socket%d|/data/vendor/qcam/camer_socket%d|g" "$BLOB_ROOT"/vendor/bin/mm-qcamera-daemon

"$MY_DIR"/setup-makefiles.sh
