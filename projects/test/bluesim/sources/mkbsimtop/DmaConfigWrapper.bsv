package DmaConfigWrapper;

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
    Bit#(32) pointerIndex;
    Bit#(64) addr;
    Bit#(32) len;
} Sglist_Request deriving (Bits);
Bit#(6) sglist_Offset = 0;

typedef struct {
    Bit#(32) pointer;
    Bit#(64) barr8;
    Bit#(32) index8;
    Bit#(64) barr4;
    Bit#(32) index4;
    Bit#(64) barr0;
    Bit#(32) index0;
} Region_Request deriving (Bits);
Bit#(6) region_Offset = 1;

typedef struct {
    Bit#(32) pointer;
    Bit#(32) offset;
} AddrRequest_Request deriving (Bits);
Bit#(6) addrRequest_Offset = 2;

typedef struct {
    ChannelType rc;
} GetStateDbg_Request deriving (Bits);
Bit#(6) getStateDbg_Offset = 3;

typedef struct {
    ChannelType rc;
} GetMemoryTraffic_Request deriving (Bits);
Bit#(6) getMemoryTraffic_Offset = 4;

// exposed wrapper portal interface
interface DmaConfigWrapperPipes;
    interface Vector#(5, PipeIn#(Bit#(32))) inputPipes;
    interface Vector#(5, Bit#(32)) requestSizeBits;
    interface PipeOut#(Sglist_Request) sglist_PipeOut;
    interface PipeOut#(Region_Request) region_PipeOut;
    interface PipeOut#(AddrRequest_Request) addrRequest_PipeOut;
    interface PipeOut#(GetStateDbg_Request) getStateDbg_PipeOut;
    interface PipeOut#(GetMemoryTraffic_Request) getMemoryTraffic_PipeOut;

endinterface
interface DmaConfigWrapperPortal;
    interface Portal#(5, 0, 32) portalIfc;
endinterface
// exposed wrapper MemPortal interface
interface DmaConfigWrapper;
    interface StdPortal portalIfc;
endinterface

instance Connectable#(DmaConfigWrapperPipes,DmaConfig);
   module mkConnection#(DmaConfigWrapperPipes pipes, DmaConfig ifc)(Empty);

    rule handle_sglist_request;
        let request <- toGet(pipes.sglist_PipeOut).get();
        ifc.sglist(request.pointer, request.pointerIndex, request.addr, request.len);
    endrule

    rule handle_region_request;
        let request <- toGet(pipes.region_PipeOut).get();
        ifc.region(request.pointer, request.barr8, request.index8, request.barr4, request.index4, request.barr0, request.index0);
    endrule

    rule handle_addrRequest_request;
        let request <- toGet(pipes.addrRequest_PipeOut).get();
        ifc.addrRequest(request.pointer, request.offset);
    endrule

    rule handle_getStateDbg_request;
        let request <- toGet(pipes.getStateDbg_PipeOut).get();
        ifc.getStateDbg(request.rc);
    endrule

    rule handle_getMemoryTraffic_request;
        let request <- toGet(pipes.getMemoryTraffic_PipeOut).get();
        ifc.getMemoryTraffic(request.rc);
    endrule

   endmodule
endinstance

// exposed wrapper Portal implementation
(* synthesize *)
module mkDmaConfigWrapperPipes#(Bit#(32) id)(DmaConfigWrapperPipes);
    Vector#(5, PipeIn#(Bit#(32))) requestPipeIn = newVector();
    Vector#(5, Bit#(32)) requestBits = newVector();
    Vector#(0, PipeOut#(Bit#(32))) indicationPipes = nil;
    Vector#(0, Bit#(32))           indicationBits = nil;

    FromBit#(32,Sglist_Request) sglist_requestFifo <- mkFromBit();
    requestPipeIn[0] = toPipeIn(sglist_requestFifo);
    requestBits[0]  = fromInteger(valueOf(SizeOf#(Sglist_Request)));

    FromBit#(32,Region_Request) region_requestFifo <- mkFromBit();
    requestPipeIn[1] = toPipeIn(region_requestFifo);
    requestBits[1]  = fromInteger(valueOf(SizeOf#(Region_Request)));

    FromBit#(32,AddrRequest_Request) addrRequest_requestFifo <- mkFromBit();
    requestPipeIn[2] = toPipeIn(addrRequest_requestFifo);
    requestBits[2]  = fromInteger(valueOf(SizeOf#(AddrRequest_Request)));

    FromBit#(32,GetStateDbg_Request) getStateDbg_requestFifo <- mkFromBit();
    requestPipeIn[3] = toPipeIn(getStateDbg_requestFifo);
    requestBits[3]  = fromInteger(valueOf(SizeOf#(GetStateDbg_Request)));

    FromBit#(32,GetMemoryTraffic_Request) getMemoryTraffic_requestFifo <- mkFromBit();
    requestPipeIn[4] = toPipeIn(getMemoryTraffic_requestFifo);
    requestBits[4]  = fromInteger(valueOf(SizeOf#(GetMemoryTraffic_Request)));

    interface Vector inputPipes = requestPipeIn;
    interface Vector requestSizeBits = requestBits;
    interface sglist_PipeOut = toPipeOut(sglist_requestFifo);
    interface region_PipeOut = toPipeOut(region_requestFifo);
    interface addrRequest_PipeOut = toPipeOut(addrRequest_requestFifo);
    interface getStateDbg_PipeOut = toPipeOut(getStateDbg_requestFifo);
    interface getMemoryTraffic_PipeOut = toPipeOut(getMemoryTraffic_requestFifo);
endmodule

module mkDmaConfigWrapperPortal#(idType id, DmaConfig ifc)(DmaConfigWrapperPortal)
    provisos (Bits#(idType, __a),
              Add#(a__, __a, 32));
    let pipes <- mkDmaConfigWrapperPipes(zeroExtend(pack(id)));
    mkConnection(pipes, ifc);
    let requestPipes = pipes.inputPipes;
    let requestBits = pipes.requestSizeBits;
    Vector#(0, PipeOut#(Bit#(32))) indicationPipes = nil;
    Vector#(0, Bit#(32)) indicationBits = nil;

    interface Portal portalIfc;
        method Bit#(32) ifcId;
            return zeroExtend(pack(id));
        endmethod
        method Bit#(32) ifcType;
            return truncate(128'hcf67a7a5fd245bcbd9eeda55a7a97415);
        endmethod
        interface Vector requests = requestPipes;
        interface Vector requestSizeBits = requestBits;
        interface Vector indications = indicationPipes;
        interface Vector indicationSizeBits = indicationBits;
    endinterface

endmodule

interface DmaConfigWrapperMemPortalPipes;
    interface DmaConfigWrapperPipes pipes;
    interface MemPortal#(16,32) portalIfc;
endinterface

(* synthesize *)
module mkDmaConfigWrapperMemPortalPipes#(Bit#(32) id)(DmaConfigWrapperMemPortalPipes);

  let p <- mkDmaConfigWrapperPipes(zeroExtend(pack(id)));

  Portal#(5, 0, 32) portalifc = (interface Portal;
        method Bit#(32) ifcId;
            return zeroExtend(pack(id));
        endmethod
        method Bit#(32) ifcType;
            return truncate(128'hcf67a7a5fd245bcbd9eeda55a7a97415);
        endmethod
        interface Vector requests = p.inputPipes;
        interface Vector requestSizeBits = p.requestSizeBits;
        interface Vector indications = nil;
        interface Vector indicationSizeBits = nil;
    endinterface);

  let memPortal <- mkMemPortal(portalifc);
  interface DmaConfigWrapperPipes pipes = p;
  interface MemPortal portalIfc = memPortal;
endmodule

// exposed wrapper MemPortal implementation
module mkDmaConfigWrapper#(idType id, DmaConfig ifc)(DmaConfigWrapper)
   provisos (Bits#(idType, a__),
	     Add#(b__, a__, 32));
  let dut <- mkDmaConfigWrapperMemPortalPipes(zeroExtend(pack(id)));
  mkConnection(dut.pipes, ifc);
  interface MemPortal portalIfc = dut.portalIfc;
endmodule
endpackage: DmaConfigWrapper
