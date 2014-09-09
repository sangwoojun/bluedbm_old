
DTOP=/home/wjun/bluedbm_work/bluedbm/simple/bluesim/bluesim
XBSVDIR=/home/wjun/bluedbm_work/xbsv
BSVPATH = /home/wjun/bluedbm_work/xbsv/lib/bsv:/home/wjun/bluedbm_work/bluedbm/src/hardware_controller/dram/simulated:/home/wjun/bluedbm_work/xbsv/generated/xilinx:/home/wjun/bluedbm_work/bluedbm/simple:/home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform:/home/wjun/bluedbm_work/xbsv/bsv
vfile=verilog/top/mkBsimTop.v

BOARD=bluesim
MKTOP=mkBsimTop
OS=android
ifeq ($(OS),android)
ALLTARGETS=android_exe bits
else
ALLTARGETS=ubuntu_exe implementation
endif

BSCFLAGS = -show-schedule -aggressive-conditions --wait-for-license -bdir $(DTOP)/obj -vdir $(DTOP)/verilog/top -simdir $(DTOP)/obj  -D TimeStamp=1404413614 
BSIM_CXX = $(XBSVDIR)/cpp/BsimCtrl.cxx $(XBSVDIR)/cpp/BsimDma.cxx $(XBSVDIR)/cpp/sock_utils.cxx $(XBSVDIR)/cpp/sock_fd.cxx

XVLOGFLAGS =
XELABFLAGS = 
XSIMFLAGS  = -R

all: $(ALLTARGETS)

S2H = InterfaceRequest DmaConfig PlatformRequest
H2S = InterfaceIndication DmaIndication PlatformIndication
BSVFILES = /home/wjun/bluedbm_work/bluedbm/simple/Interface.bsv /home/wjun/bluedbm_work/bluedbm/simple/Top.bsv /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/BlueDBMPlatform.bsv /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/PlatformInterfaces.bsv /home/wjun/bluedbm_work/bluedbm/src/hardware_controller/dram/simulated/DRAMController.bsv /home/wjun/bluedbm_work/xbsv/bsv/PortalMemory.bsv
CPPFILES=/home/wjun/bluedbm_work/bluedbm/simple/main.cpp /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/platform.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/PlatformRequestProxy.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/InterfaceRequestProxy.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/DmaConfigProxy.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/InterfaceIndicationWrapper.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/DmaIndicationWrapper.cpp /home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni/PlatformIndicationWrapper.cpp $(addprefix /home/wjun/bluedbm_work/bluedbm/simple/bluesim/bluesim/jni/, PlatformRequestProxy.cpp InterfaceRequestProxy.cpp DmaConfigProxy.cpp InterfaceIndicationWrapper.cpp DmaIndicationWrapper.cpp PlatformIndicationWrapper.cpp)

timestampfile=sources/mkbsimtop/.timestamp

$(timestampfile): /home/wjun/bluedbm_work/bluedbm/simple/Interface.bsv /home/wjun/bluedbm_work/bluedbm/simple/Top.bsv /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/BlueDBMPlatform.bsv /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/PlatformInterfaces.bsv /home/wjun/bluedbm_work/bluedbm/src/hardware_controller/dram/simulated/DRAMController.bsv /home/wjun/bluedbm_work/xbsv/bsv/PortalMemory.bsv
	cd $(DTOP); 	$(XBSVDIR)/xbsvgen -B$(BOARD) -p $(BOARD) -x $(MKTOP) 	$(foreach s2h, $(S2H), -s2h $(s2h)) 	$(foreach h2s, $(H2S), -h2s $(h2s)) 	$(foreach f, $(CPPFILES), -s $f)         -t $(XBSVDIR)/bsv/$(TOP).bsv $(XBSVFLAGS) $(BSVFILES)
	touch $(timestampfile)

$(vfile): /home/wjun/bluedbm_work/xbsv/bsv/.bsv /home/wjun/bluedbm_work/bluedbm/simple/Interface.bsv /home/wjun/bluedbm_work/bluedbm/simple/Top.bsv /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/BlueDBMPlatform.bsv /home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform/PlatformInterfaces.bsv /home/wjun/bluedbm_work/bluedbm/src/hardware_controller/dram/simulated/DRAMController.bsv /home/wjun/bluedbm_work/xbsv/bsv/PortalMemory.bsv $(timestampefile)
	mkdir -p verilog/top verilog/portal
	cd sources/mkbsimtop; mkdir -p $(DTOP)/obj; bsc  $(BSCFLAGS) -remove-dollar -p +:$(BSVPATH) -verilog -u -g mkBsimTop /home/wjun/bluedbm_work/xbsv/bsv/.bsv
	for v in verilog/top/*.v; do $(XBSVDIR)/scripts/copy_verilog.py $$v $(subst :, ,$(BSVPATH)); done

BSIM_EXE_CXX_FILES = BsimDma.cxx BsimCtrl.cxx portal.cpp sock_fd.cxx sock_utils.cxx PortalMemory.cpp
BSIM_EXE_CXX = $(addprefix $(XBSVDIR)/cpp/, $(BSIM_EXE_CXX_FILES))

bsim_exe:  $(CPPFILES) $(BSIM_EXE_CXX)
	cd jni; g++ -g -O -o bsim_exe -I$(XBSVDIR)/lib/cpp -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/bluesim/jni -I/home/wjun/bluedbm_work/bluedbm/simple -I/home/wjun/bluedbm_work/bluedbm/src/bluedbm_platform/simple_mapreduce_platform -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni -I/home/wjun/bluedbm_work/bluedbm/simple/bluesim/jni $(BSIM_EXE_CXX) $(CPPFILES) -pthread -I$(XBSVDIR) -I$(XBSVDIR)/cpp -DBSIM 

ubuntu_exe:
	cd jni; make

bsim: $(timestampfile)
	cd sources; mkdir -p $(DTOP)/obj; bsc -D BSIM  $(BSCFLAGS) -p +:$(BSVPATH):mkbsimtop/ -sim -u -g mkBsimTop /home/wjun/bluedbm_work/xbsv/bsv/.bsv
	export BSC_CXXFLAGS="-I$(XBSVDIR)/cpp -I$(XBSVDIR) -DBSIM" ; cd sources; bsc $(BSCFLAGS) -p +:$(BSVPATH):mkbsimtop/ -sim -e $(MKTOP) -o bsim $(DTOP)/obj/*.ba $(BSIM_CXX)

verilog: $(vfile)

lint: $(vfile)
	verilator --error-limit 200 --lint-only -Isources/mkbsimtop -Isources/source $(vfile)

hw/mkBsimTop.bit: $(vfile)
	vivado -mode batch -source mkbsimtop-impl.tcl

implementation: hw/mkBsimTop.bit

program:
	fpgajtag hw/mkBsimTop.bin

reprogram:
	vivado -mode batch -source mkbsimtop-reprogram.tcl
	xbsvutil reset /dev/fpga0

## for partial reconfiguration on VC707
verilog/portal/mkSynthesizeablePortalTop.v:
	mkdir -p verilog/portal
	mv -fv verilog/top/mkSynthesizeablePortalTop.v verilog/portal

## (*black_box*) causes vivado to ignore contents of the module and treat it as a black box
verilog/top/portalstub.v:
	make verilog/portal/mkSynthesizeablePortalTop.v
	cat verilog/portal/mkSynthesizeablePortalTop.v | sed 's/^module /(*black_box*)module /' > verilog/top/portalstub.v

hw/portaltop_post_synth.dcp: verilog/portal/mkSynthesizeablePortalTop.v $(vfile)
	make verilog/top/portalstub.v
	vivado -mode batch -source $(XBSVDIR)/scripts/portaltop-synth.tcl

hw/mkpcietop_post_synth.dcp:
	make verilog/top/portalstub.v
	vivado -mode batch -source $(XBSVDIR)/scripts/mkpcietop-synth.tcl

hw/mkPcieTop_pblock_portalTop_partial.bit: hw/mkpcietop_post_synth.dcp hw/portaltop_post_synth.dcp
	vivado -mode batch -source $(XBSVDIR)/scripts/mkpcietop-partial-reconfiguration.tcl

partial: hw/mkPcieTop_pblock_portalTop_partial.bit

ifeq ($(OS),android)

mkBsimTop.bit.bin.gz: hw/mkBsimTop.bit
	xxd hw/mkBsimTop.bin | sed -e "s/  .*//" -e "s/ \(..\)\(..\) \(..\)\(..\)/ \4\3 \2\1/g" | xxd -r >mkBsimTop.bit.bin
	gzip -f mkBsimTop.bit.bin
bits: mkBsimTop.bit.bin.gz

else
bits: hw/mkBsimTop.bit
endif

android_exe:
	ndk-build

ifeq ($(BOARD),bluesim)

run:
	./sources/bsim& bsimpid=$$!; echo bsimpid $$bsimpid; ./jni/bsim_exe; retcode=$$?; kill $$bsimpid; exit $$retcode

else

    ifeq ($(OS),android)

run:
	$(XBSVDIR)/scripts/run.zedboard $(RUNPARAM) `find . -name \*.gz` `find . -name android_exe | grep libs`

    else

run: program
	timeout 3m catchsegv ./jni/mkpcietop

    endif
endif

xsim: verilog
	xvlog $(XVLOGFLAGS) verilog/top/*.v
	xelab $(XELABFLAGS) work.$(MKTOP)

xsimrun: xsim
	xsim $(XSIMFLAGS) work.$(MKTOP)

JENKINS_HOST=sj9.qrclab.com
jenkins:
	$(XBSVDIR)/scripts/run.jenkins $(JENKINS_HOST) mkbsimtop $(BOARD)

hwclean:
	rm -fr obj hw vivado*.jou vivado*.log fsm_encoding.os .Xil

clean: hwclean
	rm -fr verilog
