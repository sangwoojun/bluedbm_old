
CFLAGS = -DMMAP_HW -O -g -I. -I/home/wjun/bluedbm_work/xbsv/cpp -I/home/wjun/bluedbm_work/xbsv -I/home/wjun/bluedbm_work/xbsv/lib/cpp -I/home/wjun/bluedbm_work/bluedbm/simple -I/home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform

PORTAL_CPP_FILES = $(addprefix /home/wjun/bluedbm_work/xbsv/cpp/, portal.cpp PortalMemory.cpp sock_fd.cxx sock_utils.cxx)


testmkbsimtop: PlatformRequestProxy.cpp InterfaceRequestProxy.cpp DmaConfigProxy.cpp InterfaceIndicationWrapper.cpp DmaIndicationWrapper.cpp PlatformIndicationWrapper.cpp $(PORTAL_CPP_FILES) /home/wjun/bluedbm_work/bluedbm/simple/main.cpp /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/platform.cpp
	g++ $(CFLAGS) -o mkbsimtop PlatformRequestProxy.cpp InterfaceRequestProxy.cpp DmaConfigProxy.cpp InterfaceIndicationWrapper.cpp DmaIndicationWrapper.cpp PlatformIndicationWrapper.cpp $(PORTAL_CPP_FILES) /home/wjun/bluedbm_work/bluedbm/simple/main.cpp /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/platform.cpp  -pthread 
