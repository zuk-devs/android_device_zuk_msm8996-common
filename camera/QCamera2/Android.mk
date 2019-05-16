ifneq (,$(filter $(TARGET_ARCH), arm arm64))

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
        util/QCameraBufferMaps.cpp \
        util/QCameraCmdThread.cpp \
        util/QCameraFlash.cpp \
        util/QCameraPerf.cpp \
        util/QCameraQueue.cpp \
        util/QCameraCommon.cpp \
        QCamera2Hal.cpp \
        QCamera2Factory.cpp

#HAL 3.0 source
LOCAL_SRC_FILES += \
        HAL3/QCamera3HWI.cpp \
        HAL3/QCamera3Mem.cpp \
        HAL3/QCamera3Stream.cpp \
        HAL3/QCamera3Channel.cpp \
        HAL3/QCamera3VendorTags.cpp \
        HAL3/QCamera3PostProc.cpp \
        HAL3/QCamera3CropRegionMapper.cpp \
        HAL3/QCamera3StreamMem.cpp

LOCAL_CFLAGS := -Wall -Wextra -Werror -Wno-unused-parameter -Wno-unused-variable
LOCAL_CFLAGS += -DQCAMERA_HAL3_SUPPORT
LOCAL_CFLAGS += -DHAS_MULTIMEDIA_HINTS -D_ANDROID
LOCAL_CFLAGS += -std=c++11 -std=gnu++0x
LOCAL_CFLAGS += -DHAL3 -DQCAMERA_REDEFINE_LOG
LOCAL_CFLAGS += -DVENUS_PRESENT
LOCAL_CFLAGS += -DUBWC_PRESENT

# System header file path prefix
LOCAL_CFLAGS += -DSYSTEM_HEADER_PREFIX=sys

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../mm-image-codec/qexif \
        $(LOCAL_PATH)/../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/include \
        $(LOCAL_PATH)/stack/common \
        $(LOCAL_PATH)/stack/mm-camera-interface/inc \
        $(LOCAL_PATH)/util \
        $(LOCAL_PATH)/HAL3 \
        hardware/libhardware/include/hardware \
        $(call project-path-for,qcom-media)/libstagefrighthw \
        $(call project-path-for,qcom-media)/mm-core/inc \
        system/core/include/cutils \
        system/core/include/system \
        system/media/camera/include/system \
        $(TARGET_OUT_HEADERS)/qcom/display \
        $(call project-path-for,qcom-display)/libqservice

LOCAL_HEADER_LIBRARIES := generated_kernel_headers
LOCAL_HEADER_LIBRARIES += media_plugin_headers

LOCAL_SHARED_LIBRARIES := liblog libhardware libutils libcutils libdl libsync
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface libui libcamera_metadata
LOCAL_SHARED_LIBRARIES += libqdMetaData libqservice libbinder

LOCAL_STATIC_LIBRARIES := android.hardware.camera.common@1.0-helper

LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true
LOCAL_32_BIT_ONLY := $(BOARD_QTI_CAMERA_32BIT_ONLY)

include $(BUILD_SHARED_LIBRARY)

include $(call first-makefiles-under,$(LOCAL_PATH))

endif
