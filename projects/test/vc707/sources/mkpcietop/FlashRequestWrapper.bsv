package FlashRequestWrapper;

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
    Bit#(32) wrPointer;
    Bit#(32) rdPointer;
    Bit#(32) numWords;
    Bit#(32) burstLen;
    Bit#(32) iterCnt;
} StartCopy_Request deriving (Bits);
Bit#(6) startCopy_Offset = 0;

typedef struct {
    Bit#(32) channel;
    Bit#(32) chip;
    Bit#(32) block;
    Bit#(32) page;
    Bit#(32) tag;
} ReadPage_Request deriving (Bits);
Bit#(6) readPage_Offset = 1;

typedef struct {
    Bit#(32) channel;
    Bit#(32) chip;
    Bit#(32) block;
    Bit#(32) page;
    Bit#(32) tag;
} WritePage_Request deriving (Bits);
Bit#(6) writePage_Offset = 2;

typedef struct {
    Bit#(32) data;
} SendTest_Request deriving (Bits);
Bit#(6) sendTest_Offset = 3;

typedef struct {
    Bit#(32) pointer;
    Bit#(32) idx;
} AddWriteHostBuffer_Request deriving (Bits);
Bit#(6) addWriteHostBuffer_Offset = 4;

typedef struct {
    Bit#(32) pointer;
    Bit#(32) idx;
} AddReadHostBuffer_Request deriving (Bits);
Bit#(6) addReadHostBuffer_Offset = 5;

// exposed wrapper portal interface
interface FlashRequestWrapperPipes;
    interface Vector#(6, PipeIn#(Bit#(32))) inputPipes;
    interface Vector#(6, Bit#(32)) requestSizeBits;
    interface PipeOut#(StartCopy_Request) startCopy_PipeOut;
    interface PipeOut#(ReadPage_Request) readPage_PipeOut;
    interface PipeOut#(WritePage_Request) writePage_PipeOut;
    interface PipeOut#(SendTest_Request) sendTest_PipeOut;
    interface PipeOut#(AddWriteHostBuffer_Request) addWriteHostBuffer_PipeOut;
    interface PipeOut#(AddReadHostBuffer_Request) addReadHostBuffer_PipeOut;

endinterface
interface FlashRequestWrapperPortal;
    interface Portal#(6, 0, 32) portalIfc;
endinterface
// exposed wrapper MemPortal interface
interface FlashRequestWrapper;
    interface StdPortal portalIfc;
endinterface

instance Connectable#(FlashRequestWrapperPipes,FlashRequest);
   module mkConnection#(FlashRequestWrapperPipes pipes, FlashRequest ifc)(Empty);

    rule handle_startCopy_request;
        let request <- toGet(pipes.startCopy_PipeOut).get();
        ifc.startCopy(request.wrPointer, request.rdPointer, request.numWords, request.burstLen, request.iterCnt);
    endrule

    rule handle_readPage_request;
        let request <- toGet(pipes.readPage_PipeOut).get();
        ifc.readPage(request.channel, request.chip, request.block, request.page, request.tag);
    endrule

    rule handle_writePage_request;
        let request <- toGet(pipes.writePage_PipeOut).get();
        ifc.writePage(request.channel, request.chip, request.block, request.page, request.tag);
    endrule

    rule handle_sendTest_request;
        let request <- toGet(pipes.sendTest_PipeOut).get();
        ifc.sendTest(request.data);
    endrule

    rule handle_addWriteHostBuffer_request;
        let request <- toGet(pipes.addWriteHostBuffer_PipeOut).get();
        ifc.addWriteHostBuffer(request.pointer, request.idx);
    endrule

    rule handle_addReadHostBuffer_request;
        let request <- toGet(pipes.addReadHostBuffer_PipeOut).get();
        ifc.addReadHostBuffer(request.pointer, request.idx);
    endrule

   endmodule
endinstance

// exposed wrapper Portal implementation
(* synthesize *)
module mkFlashRequestWrapperPipes#(Bit#(32) id)(FlashRequestWrapperPipes);
    Vector#(6, PipeIn#(Bit#(32))) requestPipeIn = newVector();
    Vector#(6, Bit#(32)) requestBits = newVector();
    Vector#(0, PipeOut#(Bit#(32))) indicationPipes = nil;
    Vector#(0, Bit#(32))           indicationBits = nil;

    FromBit#(32,StartCopy_Request) startCopy_requestFifo <- mkFromBit();
    requestPipeIn[0] = toPipeIn(startCopy_requestFifo);
    requestBits[0]  = fromInteger(valueOf(SizeOf#(StartCopy_Request)));

    FromBit#(32,ReadPage_Request) readPage_requestFifo <- mkFromBit();
    requestPipeIn[1] = toPipeIn(readPage_requestFifo);
    requestBits[1]  = fromInteger(valueOf(SizeOf#(ReadPage_Request)));

    FromBit#(32,WritePage_Request) writePage_requestFifo <- mkFromBit();
    requestPipeIn[2] = toPipeIn(writePage_requestFifo);
    requestBits[2]  = fromInteger(valueOf(SizeOf#(WritePage_Request)));

    FromBit#(32,SendTest_Request) sendTest_requestFifo <- mkFromBit();
    requestPipeIn[3] = toPipeIn(sendTest_requestFifo);
    requestBits[3]  = fromInteger(valueOf(SizeOf#(SendTest_Request)));

    FromBit#(32,AddWriteHostBuffer_Request) addWriteHostBuffer_requestFifo <- mkFromBit();
    requestPipeIn[4] = toPipeIn(addWriteHostBuffer_requestFifo);
    requestBits[4]  = fromInteger(valueOf(SizeOf#(AddWriteHostBuffer_Request)));

    FromBit#(32,AddReadHostBuffer_Request) addReadHostBuffer_requestFifo <- mkFromBit();
    requestPipeIn[5] = toPipeIn(addReadHostBuffer_requestFifo);
    requestBits[5]  = fromInteger(valueOf(SizeOf#(AddReadHostBuffer_Request)));

    interface Vector inputPipes = requestPipeIn;
    interface Vector requestSizeBits = requestBits;
    interface startCopy_PipeOut = toPipeOut(startCopy_requestFifo);
    interface readPage_PipeOut = toPipeOut(readPage_requestFifo);
    interface writePage_PipeOut = toPipeOut(writePage_requestFifo);
    interface sendTest_PipeOut = toPipeOut(sendTest_requestFifo);
    interface addWriteHostBuffer_PipeOut = toPipeOut(addWriteHostBuffer_requestFifo);
    interface addReadHostBuffer_PipeOut = toPipeOut(addReadHostBuffer_requestFifo);
endmodule

module mkFlashRequestWrapperPortal#(idType id, FlashRequest ifc)(FlashRequestWrapperPortal)
    provisos (Bits#(idType, __a),
              Add#(a__, __a, 32));
    let pipes <- mkFlashRequestWrapperPipes(zeroExtend(pack(id)));
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
            return truncate(128'hb0d6d3d3606045a8824b90af9c7d17a9);
        endmethod
        interface Vector requests = requestPipes;
        interface Vector requestSizeBits = requestBits;
        interface Vector indications = indicationPipes;
        interface Vector indicationSizeBits = indicationBits;
    endinterface

endmodule

interface FlashRequestWrapperMemPortalPipes;
    interface FlashRequestWrapperPipes pipes;
    interface MemPortal#(16,32) portalIfc;
endinterface

(* synthesize *)
module mkFlashRequestWrapperMemPortalPipes#(Bit#(32) id)(FlashRequestWrapperMemPortalPipes);

  let p <- mkFlashRequestWrapperPipes(zeroExtend(pack(id)));

  Portal#(6, 0, 32) portalifc = (interface Portal;
        method Bit#(32) ifcId;
            return zeroExtend(pack(id));
        endmethod
        method Bit#(32) ifcType;
            return truncate(128'hb0d6d3d3606045a8824b90af9c7d17a9);
        endmethod
        interface Vector requests = p.inputPipes;
        interface Vector requestSizeBits = p.requestSizeBits;
        interface Vector indications = nil;
        interface Vector indicationSizeBits = nil;
    endinterface);

  let memPortal <- mkMemPortal(portalifc);
  interface FlashRequestWrapperPipes pipes = p;
  interface MemPortal portalIfc = memPortal;
endmodule

// exposed wrapper MemPortal implementation
module mkFlashRequestWrapper#(idType id, FlashRequest ifc)(FlashRequestWrapper)
   provisos (Bits#(idType, a__),
	     Add#(b__, a__, 32));
  let dut <- mkFlashRequestWrapperMemPortalPipes(zeroExtend(pack(id)));
  mkConnection(dut.pipes, ifc);
  interface MemPortal portalIfc = dut.portalIfc;
endmodule
endpackage: FlashRequestWrapper
