include ../config/Makefile.list

S2H = InterfaceRequest DmaConfig
H2S = InterfaceIndication DmaIndication
BSVFILES = Interface.bsv Top.bsv 
CPPFILES=sw_interface.cpp rawWordManager.cpp
Dma = DmaF
PINS = Std

include ../config/Makefile.flashemul

XBSVDIR=../../xbsv
BOARD=vc707
TOP=$(PINS)Pcie$(Dma)Top
MKTOP=mkPcieTop

.PHONY: $(projectnames)
$(projectnames):
	$(XBSVDIR)/genxpsprojfrombsv -B$(BOARD) -p $(BOARD) -x $(MKTOP) \
	$(foreach s2h, $(S2H), -s2h $(s2h)) \
	$(foreach h2s, $(H2S), -h2s $(h2s)) \
	$(foreach f, $(CPPFILES), -s $f) \
	-t $(TOP).bsv $(XBSVFLAGS) $(BSVFILES_ALL)

