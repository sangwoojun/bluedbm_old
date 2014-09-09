

##    run: run the program
##         pass parameters to software via 'make RUN_ARGS= run'
#RUN_ARGS=

export DTOP=/home/wjun/bluedbm_work/bluedbm/projects/test/vc707
XBSVDIR=/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../
BSVPATH = /home/wjun/bluedbm_work/bluedbm/tools/xbsv/bsv:/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../generated/xilinx:/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../bsv:/home/wjun/bluedbm_work/bluedbm/xilinx/aurora_8b10b_fmc1:/home/wjun/bluedbm_work/bluedbm/projects/test:/home/wjun/bluedbm_work/bluedbm/tools/xbsv/scripts/../lib/bsv:/home/wjun/bluedbm_work/bluedbm/src/lib

BOARD=vc707
MKTOP=mkPcieTop
OS=ubuntu
DUT=mkpcietop

export S2H = FlashRequest DmaConfig
export H2S = FlashIndication DmaIndication
BSVFILES = /home/wjun/bluedbm_work/bluedbm/projects/test/Main.bsv /home/wjun/bluedbm_work/bluedbm/projects/test/Top.bsv /home/wjun/bluedbm_work/bluedbm/xilinx/aurora_8b10b_fmc1/AuroraImportFmc1.bsv /home/wjun/bluedbm_work/bluedbm/src/lib/PageCache.bsv /home/wjun/bluedbm_work/bluedbm/tools/xbsv/bsv/PortalMemory.bsv /home/wjun/bluedbm_work/bluedbm/tools/xbsv/bsv/DisplayInd.bsv

BSCFLAGS_PROJECT = +RTS -K46777216 -RTS  -D DataBusWidth=128
BSIM_CXX_PROJECT = 
XELABFLAGS = 
XSIMFLAGS  = -R
TOPBSVFILE = /home/wjun/bluedbm_work/bluedbm/tools/xbsv/bsv/PcieTop.bsv
BSVDEFINES =  -D NumberOfMasters=1 -D IMPORT_HOSTIF -D PinType=Top_Pins -D project_dir=/home/wjun/bluedbm_work/bluedbm/projects/test/vc707 -D Virtex7 -D PCIE -D PcieHostTypeIF -D PhysAddrWidth=40 -D BOARD_vc707
QTUSED = 
export BSVDEFINES_LIST = NumberOfMasters=1 IMPORT_HOSTIF PinType=Top_Pins project_dir=/home/wjun/bluedbm_work/bluedbm/projects/test/vc707 Virtex7 PCIE PcieHostTypeIF PhysAddrWidth=40 BOARD_vc707
export DUT_NAME = mkPcieTop

NumberOfMasters="1"
IMPORT_HOSTIF=""
PinType="Top_Pins"
project_dir="/home/wjun/bluedbm_work/bluedbm/projects/test/vc707"
Virtex7=""
PCIE=""
PcieHostTypeIF=""
PhysAddrWidth="40"
BOARD_vc707=""

include $(XBSVDIR)/scripts/Makefile.xbsv.build


FPGAMAKE=$(XBSVDIR)/../fpgamake/fpgamake
fpgamake.mk: $(vfile) Makefile prepare_bin_target
	$(Q)mkdir -p hw
	$(Q)$(FPGAMAKE) $(FPGAMAKE_VERBOSE) -o fpgamake.mk -s mkPcieEndpointX7 -s mkPcieHost --floorplan= --xdc=/home/wjun/bluedbm_work/bluedbm/xilinx/aurora_8b10b_fmc1/aurora_8b10b_fmc1_exdes.xdc --xdc=/home/wjun/bluedbm_work/bluedbm/tools/xbsv/xilinx/constraints/vc707.xdc --xci=/home/wjun/bluedbm_work/bluedbm/tools/xbsv/out/vc707/pcie_7x_0/pcie_7x_0.xci --xci=/home/wjun/bluedbm_work/bluedbm/tools/xbsv/out/vc707/aurora_8b10b_fmc1/aurora_8b10b_fmc1.xci  -t $(MKTOP)  -b hw/mkTop.bit verilog $(XBSVDIR)/verilog /home/wjun/bluedbm_work/bluedbm/xilinx/aurora_8b10b_fmc1 /home/wjun/bluedbm_work/bluedbm/tools/xbsv/verilog

hw/mkTop.bit: fpgamake.mk prepare_bin_target
	$(Q)make -f fpgamake.mk
	$(Q)cp -f Impl/*/*.rpt bin

