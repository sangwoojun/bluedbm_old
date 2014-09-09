
include $(CLEAR_VARS)
LOCAL_ARM_MODE := arm
include /home/wjun/bluedbm_work/bluedbm/projects/test/bluesim/jni/Makefile.generated_files
APP_SRC_FILES := $(addprefix /home/wjun/bluedbm_work/bluedbm/projects/test/bluesim/jni/,  $(GENERATED_CPP)) /home/wjun/bluedbm_work/bluedbm/projects/test/main.cpp /home/wjun/bluedbm_work/bluedbm/tools/xbsv/cpp/dmaManager.c
PORTAL_SRC_FILES := $(addprefix /home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//cpp/, portal.c poller.cpp sock_utils.c timer.c)
LOCAL_SRC_FILES := $(APP_SRC_FILES) $(PORTAL_SRC_FILES)

LOCAL_PATH :=
LOCAL_MODULE := android_exe
LOCAL_MODULE_TAGS := optional
LOCAL_LDLIBS := -llog   
LOCAL_CPPFLAGS := "-march=armv7-a"
LOCAL_CFLAGS := -DZYNQ -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../ -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//cpp -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//lib/cpp -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/zynqportal -I/home/wjun/bluedbm_work/bluedbm/projects/test/bluesim/jni  -DNumberOfMasters=1 -DIMPORT_HOSTIF -DPinType=Top_Pins -Dproject_dir=/home/wjun/bluedbm_work/bluedbm/projects/test/bluesim -DBsimHostTypeIF -DPhysAddrWidth=40 -DBOARD_bluesim -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/portalmem
LOCAL_CXXFLAGS := -DZYNQ -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../ -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//cpp -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//lib/cpp -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/zynqportal -I/home/wjun/bluedbm_work/bluedbm/projects/test/bluesim/jni  -DNumberOfMasters=1 -DIMPORT_HOSTIF -DPinType=Top_Pins -Dproject_dir=/home/wjun/bluedbm_work/bluedbm/projects/test/bluesim -DBsimHostTypeIF -DPhysAddrWidth=40 -DBOARD_bluesim -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/portalmem

include $(BUILD_EXECUTABLE)
