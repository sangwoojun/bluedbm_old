package DmaIndicationProxy;

import FIFO::*;
import FIFOF::*;
import GetPut::*;
import Connectable::*;
import Clocks::*;
import FloatingPoint::*;
import Adapter::*;
import Leds::*;
import Vector::*;
import SpecialFIFOs::*;
import PortalMemory::*;
import Portal::*;
import MemPortal::*;
import MemTypes::*;
import Pipe::*;
import PortalMemory::*;




typedef struct {
    Bit#(32) pointer;
} ConfigResp_Response deriving (Bits);
Bit#(6) configResp_Offset = 0;

typedef struct {
    Bit#(64) physAddr;
} AddrResponse_Response deriving (Bits);
Bit#(6) addrResponse_Offset = 1;

typedef struct {
    DmaDbgRec rec;
} ReportStateDbg_Response deriving (Bits);
Bit#(6) reportStateDbg_Offset = 2;

typedef struct {
    Bit#(64) words;
} ReportMemoryTraffic_Response deriving (Bits);
Bit#(6) reportMemoryTraffic_Offset = 3;

typedef struct {
    Bit#(32) code;
    Bit#(32) pointer;
    Bit#(64) offset;
    Bit#(64) extra;
} DmaError_Response deriving (Bits);
Bit#(6) dmaError_Offset = 4;

// exposed proxy interface
interface DmaIndicationProxyPortal;
    interface Portal#(0, 5, 32) portalIfc;
    interface DmaIndication ifc;
endinterface
interface DmaIndicationProxy;
    interface StdPortal portalIfc;
    interface DmaIndication ifc;
endinterface

(* synthesize *)
module  mkDmaIndicationProxyPortalSynth#(Bit#(32) id) (DmaIndicationProxyPortal);
    Vector#(0, PipeIn#(Bit#(32))) requestPipes = nil;
    Vector#(0, Bit#(32))          requestBits = nil;
    Vector#(5, PipeOut#(Bit#(32))) indicationPipes = newVector();
    Vector#(5, Bit#(32))           indicationBits = newVector();

    ToBit#(32,ConfigResp_Response) configResp_responseFifo <- mkToBit();
    indicationPipes[0] = toPipeOut(configResp_responseFifo);
    indicationBits[0]  = fromInteger(valueOf(SizeOf#(ConfigResp_Response)));

    ToBit#(32,AddrResponse_Response) addrResponse_responseFifo <- mkToBit();
    indicationPipes[1] = toPipeOut(addrResponse_responseFifo);
    indicationBits[1]  = fromInteger(valueOf(SizeOf#(AddrResponse_Response)));

    ToBit#(32,ReportStateDbg_Response) reportStateDbg_responseFifo <- mkToBit();
    indicationPipes[2] = toPipeOut(reportStateDbg_responseFifo);
    indicationBits[2]  = fromInteger(valueOf(SizeOf#(ReportStateDbg_Response)));

    ToBit#(32,ReportMemoryTraffic_Response) reportMemoryTraffic_responseFifo <- mkToBit();
    indicationPipes[3] = toPipeOut(reportMemoryTraffic_responseFifo);
    indicationBits[3]  = fromInteger(valueOf(SizeOf#(ReportMemoryTraffic_Response)));

    ToBit#(32,DmaError_Response) dmaError_responseFifo <- mkToBit();
    indicationPipes[4] = toPipeOut(dmaError_responseFifo);
    indicationBits[4]  = fromInteger(valueOf(SizeOf#(DmaError_Response)));

    interface DmaIndication ifc;

    method Action configResp(Bit#(32) pointer);
        configResp_responseFifo.enq(ConfigResp_Response {pointer: pointer});
        //$display("indicationMethod 'configResp' invoked");
    endmethod
    method Action addrResponse(Bit#(64) physAddr);
        addrResponse_responseFifo.enq(AddrResponse_Response {physAddr: physAddr});
        //$display("indicationMethod 'addrResponse' invoked");
    endmethod
    method Action reportStateDbg(DmaDbgRec rec);
        reportStateDbg_responseFifo.enq(ReportStateDbg_Response {rec: rec});
        //$display("indicationMethod 'reportStateDbg' invoked");
    endmethod
    method Action reportMemoryTraffic(Bit#(64) words);
        reportMemoryTraffic_responseFifo.enq(ReportMemoryTraffic_Response {words: words});
        //$display("indicationMethod 'reportMemoryTraffic' invoked");
    endmethod
    method Action dmaError(Bit#(32) code, Bit#(32) pointer, Bit#(64) offset, Bit#(64) extra);
        dmaError_responseFifo.enq(DmaError_Response {code: code, pointer: pointer, offset: offset, extra: extra});
        //$display("indicationMethod 'dmaError' invoked");
    endmethod
    endinterface

    interface Portal portalIfc;
        method Bit#(32) ifcId;
            return zeroExtend(pack(id));
        endmethod
        method Bit#(32) ifcType;
            return truncate(128'h763a0d8943c25f2e6d8391c1c8ecbbbd);
        endmethod
        interface Vector requests = requestPipes;
        interface Vector requestSizeBits = requestBits;
        interface Vector indications = indicationPipes;
        interface Vector indicationSizeBits = indicationBits;
    endinterface

endmodule

// exposed proxy implementation
module  mkDmaIndicationProxyPortal#(idType id) (DmaIndicationProxyPortal)
    provisos (Bits#(idType, __a),
              Add#(a__, __a, 32));
    let rv <- mkDmaIndicationProxyPortalSynth(extend(pack(id)));
    return rv;
endmodule

// synthesizeable proxy MemPortal
(* synthesize *)
module mkDmaIndicationProxySynth#(Bit#(32) id)(DmaIndicationProxy);
  let dut <- mkDmaIndicationProxyPortal(id);
  let memPortal <- mkMemPortal(dut.portalIfc);
  interface MemPortal portalIfc = memPortal;
  interface DmaIndication ifc = dut.ifc;
endmodule

// exposed proxy MemPortal
module mkDmaIndicationProxy#(idType id)(DmaIndicationProxy)
   provisos (Bits#(idType, a__),
	     Add#(b__, a__, 32));
   let rv <- mkDmaIndicationProxySynth(extend(pack(id)));
   return rv;
endmodule
endpackage: DmaIndicationProxy
