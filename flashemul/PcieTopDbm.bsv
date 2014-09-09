// Copyright (c) 2014 Quanta Research Cambridge, Inc.

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Vector            :: *;
import GetPut            :: *;
import Connectable       :: *;
import Xilinx            :: *;
import PcieSplitter      :: *;
import X7PcieSplitter    :: *;
import Portal            :: *;
import Leds              :: *;
import Top               :: *;
import AxiSlaveEngine    :: *;
import AxiMasterEngine   :: *;
import AxiMasterSlave    :: *;
import AxiDma            :: *;
import AxiCsr            :: *;

import AuroraImportVC707 :: *;

typedef (function Module#(PortalTop#(40, dsz, ipins, nMasters)) mkPortalTop(Clock clk, Reset rst, 
			  Vector#(QuadCount, Clock) gtx_clk_p,
			  Vector#(QuadCount, Clock) gtx_clk_n
		)) MkPortalTop#(numeric type dsz, type ipins, numeric type nMasters);

`ifdef Artix7
typedef 4 PcieLanes;
typedef 4 NumLeds;
`else
typedef 8 PcieLanes;
typedef 8 NumLeds;
`endif

interface PcieTop#(type ipins);
   (* prefix="PCIE" *)
   interface PCIE_EXP#(PcieLanes) pcie;
   (* always_ready *)
   method Bit#(NumLeds) leds();
   interface ipins       pins;
endinterface

(* no_default_clock, no_default_reset *)
module [Module] mkPcieTopFromPortal #(Clock pci_sys_clk_p, Clock pci_sys_clk_n,
				      Clock sys_clk_p,     Clock sys_clk_n,
				      Reset pci_sys_reset_n,
					  Vector#(QuadCount, Clock) gtx_clk_p,
					  Vector#(QuadCount, Clock) gtx_clk_n,
				      MkPortalTop#(dsz, ipins, nMasters) mkPortalTop)
   (PcieTop#(ipins))
   provisos (Mul#(TDiv#(dsz, 32), 32, dsz),
	     Add#(b__, 32, dsz),
	     Add#(c__, dsz, 256),
	     Add#(d__, TMul#(8, TDiv#(dsz, 32)), 64),
	     Add#(e__, TMul#(32, TDiv#(dsz, 32)), 256),
	     Add#(f__, TDiv#(dsz, 32), 8),
	     Mul#(TDiv#(dsz, 8), 8, dsz),
	     Add#(g__, nMasters, 1)
      );

   let contentId = 0;

   X7PcieSplitter#(PcieLanes) x7pcie <- mkX7PcieSplitter(pci_sys_clk_p, pci_sys_clk_n, sys_clk_p, sys_clk_n, pci_sys_reset_n,
							 contentId );
   
   // instantiate user portals
   //Clock sys_clk <- mkClockIBUFDS(sys_clk_p, sys_clk_n);
   let portalTop <- mkPortalTop(x7pcie.clock200, pci_sys_reset_n, gtx_clk_p, gtx_clk_n, clocked_by x7pcie.clock125, reset_by x7pcie.portalReset);
   AxiSlaveEngine#(dsz) axiSlaveEngine <- mkAxiSlaveEngine(x7pcie.pciId(), clocked_by x7pcie.clock125, reset_by x7pcie.reset125);
   AxiMasterEngine axiMasterEngine <- mkAxiMasterEngine(x7pcie.pciId(), clocked_by x7pcie.clock125, reset_by x7pcie.reset125);

   mkConnection(tpl_1(x7pcie.slave), tpl_2(axiSlaveEngine.tlps), clocked_by x7pcie.clock125, reset_by x7pcie.reset125);
   mkConnection(tpl_1(axiSlaveEngine.tlps), tpl_2(x7pcie.slave), clocked_by x7pcie.clock125, reset_by x7pcie.reset125);
   Vector#(nMasters,Axi3Master#(40,dsz,6)) m_axis;   
   if(valueOf(nMasters) > 0) begin
      m_axis[0] <- mkAxiDmaMaster(portalTop.masters[0],clocked_by x7pcie.clock125, reset_by x7pcie.portalReset);
      mkConnection(m_axis[0], axiSlaveEngine.slave, clocked_by x7pcie.clock125, reset_by x7pcie.reset125);
   end

   mkConnection(tpl_1(x7pcie.master), axiMasterEngine.tlp_in);
   mkConnection(axiMasterEngine.tlp_out, tpl_2(x7pcie.master));

   Axi3Slave#(32,32,12) ctrl <- mkAxiDmaSlave(portalTop.slave, clocked_by x7pcie.clock125, reset_by x7pcie.reset125);
   mkConnection(axiMasterEngine.master, ctrl, clocked_by x7pcie.clock125, reset_by x7pcie.reset125);

   // going from level to edge-triggered interrupt
   Vector#(15, Reg#(Bool)) interruptRequested <- replicateM(mkReg(False, clocked_by x7pcie.clock125, reset_by x7pcie.reset125));
   for (Integer i = 0; i < 15; i = i + 1) begin
      // intr_num 0 for the directory
      Integer intr_num = i+1;
      MSIX_Entry msixEntry = x7pcie.msixEntry[intr_num];
      rule interruptRequest;
	 if (portalTop.interrupt[i] && !interruptRequested[i])
	    axiMasterEngine.interruptRequest.put(tuple2({msixEntry.addr_hi, msixEntry.addr_lo}, msixEntry.msg_data));
	 interruptRequested[i] <= portalTop.interrupt[i];
      endrule
   end

   interface pcie = x7pcie.pcie;
   //interface ddr3 = x7pcie.ddr3;
   method Bit#(NumLeds) leds();
      return extend({pack(x7pcie.isLinkUp()),3'd2});
   endmethod
   interface pins = portalTop.pins;

endmodule: mkPcieTopFromPortal

