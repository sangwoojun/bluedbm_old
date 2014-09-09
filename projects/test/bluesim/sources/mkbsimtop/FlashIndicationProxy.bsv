package FlashIndicationProxy;

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
import Main::*;




typedef struct {
    Bit#(32) padding;
} Started_Response deriving (Bits);
Bit#(6) started_Offset = 0;

typedef struct {
    Bit#(32) tag;
} ReadDone_Response deriving (Bits);
Bit#(6) readDone_Offset = 1;

typedef struct {
    Bit#(32) tag;
} WriteDone_Response deriving (Bits);
Bit#(6) writeDone_Offset = 2;

typedef struct {
    Bit#(32) data;
} HexDump_Response deriving (Bits);
Bit#(6) hexDump_Offset = 3;

// exposed proxy interface
interface FlashIndicationProxyPortal;
    interface Portal#(0, 4, 32) portalIfc;
    interface FlashIndication ifc;
endinterface
interface FlashIndicationProxy;
    interface StdPortal portalIfc;
    interface FlashIndication ifc;
endinterface

(* synthesize *)
module  mkFlashIndicationProxyPortalSynth#(Bit#(32) id) (FlashIndicationProxyPortal);
    Vector#(0, PipeIn#(Bit#(32))) requestPipes = nil;
    Vector#(0, Bit#(32))          requestBits = nil;
    Vector#(4, PipeOut#(Bit#(32))) indicationPipes = newVector();
    Vector#(4, Bit#(32))           indicationBits = newVector();

    ToBit#(32,Started_Response) started_responseFifo <- mkToBit();
    indicationPipes[0] = toPipeOut(started_responseFifo);
    indicationBits[0]  = fromInteger(valueOf(SizeOf#(Started_Response)));

    ToBit#(32,ReadDone_Response) readDone_responseFifo <- mkToBit();
    indicationPipes[1] = toPipeOut(readDone_responseFifo);
    indicationBits[1]  = fromInteger(valueOf(SizeOf#(ReadDone_Response)));

    ToBit#(32,WriteDone_Response) writeDone_responseFifo <- mkToBit();
    indicationPipes[2] = toPipeOut(writeDone_responseFifo);
    indicationBits[2]  = fromInteger(valueOf(SizeOf#(WriteDone_Response)));

    ToBit#(32,HexDump_Response) hexDump_responseFifo <- mkToBit();
    indicationPipes[3] = toPipeOut(hexDump_responseFifo);
    indicationBits[3]  = fromInteger(valueOf(SizeOf#(HexDump_Response)));

    interface FlashIndication ifc;

    method Action started();
        started_responseFifo.enq(Started_Response {padding: 0});
        //$display("indicationMethod 'started' invoked");
    endmethod
    method Action readDone(Bit#(32) tag);
        readDone_responseFifo.enq(ReadDone_Response {tag: tag});
        //$display("indicationMethod 'readDone' invoked");
    endmethod
    method Action writeDone(Bit#(32) tag);
        writeDone_responseFifo.enq(WriteDone_Response {tag: tag});
        //$display("indicationMethod 'writeDone' invoked");
    endmethod
    method Action hexDump(Bit#(32) data);
        hexDump_responseFifo.enq(HexDump_Response {data: data});
        //$display("indicationMethod 'hexDump' invoked");
    endmethod
    endinterface

    interface Portal portalIfc;
        method Bit#(32) ifcId;
            return zeroExtend(pack(id));
        endmethod
        method Bit#(32) ifcType;
            return truncate(128'h93f9d3fcbe120f19d4b5751ee1220bbc);
        endmethod
        interface Vector requests = requestPipes;
        interface Vector requestSizeBits = requestBits;
        interface Vector indications = indicationPipes;
        interface Vector indicationSizeBits = indicationBits;
    endinterface

endmodule

// exposed proxy implementation
module  mkFlashIndicationProxyPortal#(idType id) (FlashIndicationProxyPortal)
    provisos (Bits#(idType, __a),
              Add#(a__, __a, 32));
    let rv <- mkFlashIndicationProxyPortalSynth(extend(pack(id)));
    return rv;
endmodule

// synthesizeable proxy MemPortal
(* synthesize *)
module mkFlashIndicationProxySynth#(Bit#(32) id)(FlashIndicationProxy);
  let dut <- mkFlashIndicationProxyPortal(id);
  let memPortal <- mkMemPortal(dut.portalIfc);
  interface MemPortal portalIfc = memPortal;
  interface FlashIndication ifc = dut.ifc;
endmodule

// exposed proxy MemPortal
module mkFlashIndicationProxy#(idType id)(FlashIndicationProxy)
   provisos (Bits#(idType, a__),
	     Add#(b__, a__, 32));
   let rv <- mkFlashIndicationProxySynth(extend(pack(id)));
   return rv;
endmodule
endpackage: FlashIndicationProxy
