
export V=0
ifeq ($(V),0)
Q=@
else
Q=
endif

CFLAGS_COMMON = -O -g -I/home/wjun/bluedbm_work/bluedbm/projects/test/vc707/jni -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../ -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//cpp -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//lib/cpp -I/home/wjun/bluedbm_work/bluedbm/projects/test -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/cpp  -DNumberOfMasters=1 -DIMPORT_HOSTIF -DPinType=Top_Pins -Dproject_dir=/home/wjun/bluedbm_work/bluedbm/projects/test/vc707 -DVirtex7 -DPCIE -DPcieHostTypeIF -DPhysAddrWidth=40 -DBOARD_vc707 -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/portalmem -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/pcieportal -I/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//drivers/zynqportal
CFLAGS = $(CFLAGS_COMMON)

PORTAL_CPP_FILES = $(addprefix /home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//cpp/, portal.c poller.cpp sock_utils.c timer.c)
include /home/wjun/bluedbm_work/bluedbm/projects/test/vc707/jni/Makefile.generated_files
SOURCES = $(addprefix /home/wjun/bluedbm_work/bluedbm/projects/test/vc707/jni/,  $(GENERATED_CPP)) /home/wjun/bluedbm_work/bluedbm/projects/test/main.cpp /home/wjun/bluedbm_work/bluedbm/tools/xbsv/cpp/dmaManager.c $(PORTAL_CPP_FILES)
LDLIBS :=   -pthread 

BSIM_EXE_CXX_FILES = BsimDma.cxx BsimCtrl.cxx TlpReplay.cxx
BSIM_EXE_CXX = $(addprefix /home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/..//cpp/, $(BSIM_EXE_CXX_FILES))

ubuntu_exe: $(SOURCES)
	$(Q)g++ $(CFLAGS) -o ubuntu_exe $(SOURCES) $(LDLIBS)

bsim_exe: $(SOURCES)
	$(Q)g++ $(CFLAGS_COMMON) -o bsim_exe -DBSIM $(SOURCES) $(BSIM_EXE_CXX) $(LDLIBS)
