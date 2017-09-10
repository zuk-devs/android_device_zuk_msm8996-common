LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(call all-java-files-under, src)

LOCAL_PACKAGE_NAME := ZukPref
LOCAL_PRIVATE_PLATFORM_APIS := true
LOCAL_CERTIFICATE := platform
LOCAL_VENDOR_MODULE := true

LOCAL_STATIC_ANDROID_LIBRARIES := \
    android-support-v7-appcompat \
    android-support-v7-preference \
    android-support-v7-recyclerview \
    android-support-v14-preference

LOCAL_PROGUARD_FLAG_FILES := proguard.flags
LOCAL_RESOURCE_DIR := \
    $(LOCAL_PATH)/res

include $(BUILD_PACKAGE)

include $(call all-makefiles-under,$(LOCAL_PATH))
