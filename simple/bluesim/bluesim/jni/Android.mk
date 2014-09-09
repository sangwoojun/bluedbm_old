
include $(CLEAR_VARS)
LOCAL_ARM_MODE := arm
APP_SRC_FILES := $(addprefix /home/wjun/bluedbm_work/bluedbm/simple/bluesim/bluesim/jni/,  PlatformRequestProxy.cpp InterfaceRequestProxy.cpp DmaConfigProxy.cpp InterfaceIndicationWrapper.cpp DmaIndicationWrapper.cpp PlatformIndicationWrapper.cpp) /home/wjun/bluedbm_work/bluedbm/simple/main.cpp /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/platform.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/PlatformRequestProxy.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/InterfaceRequestProxy.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/DmaConfigProxy.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/InterfaceIndicationWrapper.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/DmaIndicationWrapper.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/PlatformIndicationWrapper.cpp
PORTAL_SRC_FILES := $(addprefix /home/wjun/bluedbm_work/xbsv/cpp/, portal.cpp PortalMemory.cpp sock_fd.cxx sock_utils.cxx)
LOCAL_SRC_FILES := $(APP_SRC_FILES) $(PORTAL_SRC_FILES)

LOCAL_PATH :=
LOCAL_MODULE := android_exe
LOCAL_MODULE_TAGS := optional
LOCAL_LDLIBS := -llog
LOCAL_CPPFLAGS := "-march=armv7-a"
LOCAL_CXXFLAGS := -DZYNQ -DMMAP_HW -I/home/wjun/bluedbm_work/xbsv -I/home/wjun/bluedbm_work/xbsv/lib/cpp -I/home/wjun/bluedbm_work/xbsv/cpp -I/home/wjun/bluedbm_work/xbsv/drivers/zynqportal -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/bluesim/jni

#NDK_OUT := obj/

include $(BUILD_EXECUTABLE)
