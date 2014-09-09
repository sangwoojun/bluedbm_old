package InterfaceRequestWrapper;

import FIFO::*;
import FIFOF::*;
import GetPut::*;
import Connectable::*;
import Clocks::*;
import Adapter::*;
import Leds::*;
import Vector::*;
import SpecialFIFOs::*;
import PortalMemory::*;
import Portal::*;
import Dma::*;
import Interface::*;


typedef struct {
    Bit#(1) select;
    Bit#(6) tag;
} ReadReqInfo deriving (Bits);



typedef struct {
    Bit#(32) v;
} PutFailed$Response deriving (Bits);
Bit#(6) putFailed$Offset = 0;

// hidden proxy interface
interface InterfaceRequestWrapperStatus;

    method Action putFailed(Bit#(32) v);
    interface ReadOnly#(Bool) interrupt;
endinterface

// hidden proxy implementation
module  mkInterfaceRequestWrapperStatus#(FIFO#(Bit#(15)) slaveWriteAddrFifo,
                            FIFO#(Bit#(15)) slaveReadAddrFifo,
                            FIFO#(Bit#(32)) slaveWriteDataFifo,
                            FIFOF#(Bit#(32)) slaveReadDataFifo)(InterfaceRequestWrapperStatus);

    // indication-specific state
    Reg#(Bit#(32)) underflowReadCountReg <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeReadCountReg <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeWriteCount <- mkReg(0);
    Vector#(1, Bool) readyBits = replicate(False);

    Reg#(Bool) interruptEnableReg <- mkReg(False);
    function Bit#(32) read_wire_cvt (PulseWire a) = a._read ? 32'b1 : 32'b0;
    function Bit#(32) my_add(Bit#(32) a, Bit#(32) b) = a+b;

    rule writeCtrlReg if (slaveWriteAddrFifo.first[14] == 1);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
	let addr = slaveWriteAddrFifo.first[13:0];
	let v = slaveWriteDataFifo.first;
	if (addr == 14'h000)
	    noAction;
	if (addr == 14'h004)
	    interruptEnableReg <= v[0] == 1'd1;
    endrule
    rule writeIndicatorFifo if (slaveWriteAddrFifo.first[14] == 0);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        outOfRangeWriteCount <= outOfRangeWriteCount + 1;
    endrule


    ToBit#(32,PutFailed$Response) putFailed$responseFifo <- mkToBit();
    rule putFailed$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == putFailed$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (putFailed$responseFifo.notEmpty) begin
            putFailed$responseFifo.deq;
            v = putFailed$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[putFailed$Offset] = putFailed$responseFifo.notEmpty;


    Bool      interruptStatus = False;
    Bit#(32)  readyChannel = -1;
    for (Integer i = 0; i < 1; i = i + 1) begin
        if (readyBits[i]) begin
           interruptStatus = True;
           readyChannel = fromInteger(i);
        end
    end

    rule readCtrlReg if (slaveReadAddrFifo.first[14] == 1);

        slaveReadAddrFifo.deq;
	let addr = slaveReadAddrFifo.first[13:0];

        //$display("proxy readCtrlReg %h", addr);

	Bit#(32) v = 32'h05a05a0;
	if (addr == 14'h000)
	    v = interruptStatus ? 32'd1 : 32'd0;
	if (addr == 14'h004)
	    v = interruptEnableReg ? 32'd1 : 32'd0;
	if (addr == 14'h008)
	    v = 1;
	if (addr == 14'h00C)
	    v = underflowReadCountReg;
	if (addr == 14'h010)
	    v = outOfRangeReadCountReg;
	if (addr == 14'h014)
	    v = outOfRangeWriteCount;
        if (addr == 14'h018) begin
            if (interruptStatus)
              v = readyChannel+1;
            else 
              v = 0;
        end

        slaveReadDataFifo.enq(v);
    endrule

    rule outOfRangeRead if (slaveReadAddrFifo.first[14] == 0 && 
                            slaveReadAddrFifo.first[13:8] >= 1);
        slaveReadAddrFifo.deq;
        slaveReadDataFifo.enq(0);
        outOfRangeReadCountReg <= outOfRangeReadCountReg+1;
    endrule



    method Action putFailed(Bit#(32) v);
        putFailed$responseFifo.enq(PutFailed$Response {v: v});
        //$display("indicationMethod 'putFailed' invoked");
    endmethod



    interface ReadOnly interrupt;
        method Bool _read();
            return (interruptEnableReg && interruptStatus);
        endmethod
    endinterface

endmodule


typedef struct {
    Bit#(32) hostHandle;
} SetDmaHandle$Request deriving (Bits);
Bit#(6) setDmaHandle$Offset = 0;

typedef struct {
    Bit#(64) pageIdx;
    Bit#(32) tag;
} ReadPage$Request deriving (Bits);
Bit#(6) readPage$Offset = 1;

typedef struct {
    Bit#(64) pageIdx;
    Bit#(32) tag;
} WritePage$Request deriving (Bits);
Bit#(6) writePage$Offset = 2;

typedef struct {
    Bit#(64) data;
} ReadRawWord$Request deriving (Bits);
Bit#(6) readRawWord$Offset = 3;

// exposed wrapper interface
interface InterfaceRequestWrapper;
    interface StdPortal portalIfc;
endinterface

// exposed wrapper implementation
module mkInterfaceRequestWrapper#(idType id, InterfaceRequest ifc)(InterfaceRequestWrapper)
    provisos (Bits#(idType, __a), 
              Add#(a__, __a, 32));

    // state used to implement Slave interface
    Reg#(Bit#(15)) slaveReadAddrReg <- mkReg(0);
    Reg#(Bit#(15)) slaveWriteAddrReg <- mkReg(0);
    Reg#(Bit#(6)) slaveReadTagReg <- mkReg(0);
    Reg#(Bit#(6)) slaveWriteTagReg <- mkReg(0);
    FIFOF#(ReadReqInfo) slaveReadReqInfoFifo <- mkFIFOF;
    Reg#(Bit#(8)) slaveReadBurstCountReg <- mkReg(0);
    Reg#(Bit#(8)) slaveWriteBurstCountReg <- mkReg(0);
    FIFOF#(Bit#(6)) slaveBrespFifo <- mkFIFOF();

    Vector#(2,FIFO#(Bit#(15))) slaveWriteAddrFifos <- replicateM(mkFIFO);
    Vector#(2,FIFO#(Bit#(15))) slaveReadAddrFifos <- replicateM(mkFIFO);
    Vector#(2,FIFO#(Bit#(32))) slaveWriteDataFifos <- replicateM(mkFIFO);
    Vector#(2,FIFOF#(Bit#(32))) slaveReadDataFifos <- replicateM(mkFIFOF);

    Reg#(Bit#(1)) slaveRS <- mkReg(0);
    Reg#(Bit#(1)) slaveWS <- mkReg(0);

    FIFO#(MemRequest#(16))  req_ar_fifo <- mkSizedFIFO(1);
    FIFO#(MemRequest#(16)) req_aw_fifo <- mkSizedFIFO(1);

    let slaveWriteAddrFifo = slaveWriteAddrFifos[0];
    let slaveReadAddrFifo  = slaveReadAddrFifos[0];
    let slaveWriteDataFifo = slaveWriteDataFifos[0];
    let slaveReadDataFifo  = slaveReadDataFifos[0];

    rule slaveReadAddressGenerator;
         if (slaveReadBurstCountReg == 0) begin
             let req = req_ar_fifo.first;
             slaveRS <= req.addr[15];
             slaveReadBurstCountReg <= req.burstLen;
             slaveReadAddrReg <= truncate(req.addr);
	     slaveReadTagReg <= req.tag;
             req_ar_fifo.deq;
         end
         else begin
             slaveReadAddrFifos[slaveRS].enq(truncate(slaveReadAddrReg));
             slaveReadAddrReg <= slaveReadAddrReg + 4;
             slaveReadBurstCountReg <= slaveReadBurstCountReg - 1;
             slaveReadReqInfoFifo.enq(ReadReqInfo { select: slaveRS, tag: slaveReadTagReg });
         end
    endrule 

    // instantiate hidden proxy to report put failures
    InterfaceRequestWrapperStatus p <- mkInterfaceRequestWrapperStatus(slaveWriteAddrFifos[1],
                                           slaveReadAddrFifos[1],
                                           slaveWriteDataFifos[1],
                                           slaveReadDataFifos[1]);

    // request-specific state
    Reg#(Bit#(32)) requestFiredCount <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeWriteCount <- mkReg(0);
    PulseWire requestFiredPulse <- mkPulseWireOR();
    // this is here to get rid of bsv warnings.  
    Reg#(Bool) putEnable <- mkReg(True); 

    rule requestFiredIncrement if (requestFiredPulse);
        requestFiredCount <= requestFiredCount+1;
    endrule

    rule writeCtrlReg if (slaveWriteAddrFifo.first[14] == 1);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
	let addr = slaveWriteAddrFifo.first[13:0];
	let v = slaveWriteDataFifo.first;
	if (addr == 14'h000)
	    noAction;
	if (addr == 14'h004)
	    noAction;
        if (addr == 14'h008)
            putEnable <= v[0] == 1'd1;
    endrule

    rule readCtrlReg if (slaveReadAddrFifo.first[14] == 1);
        slaveReadAddrFifo.deq;
	let addr = slaveReadAddrFifo.first[13:0];
        // $display("wrapper readCtrlReg %h", addr);
	Bit#(32) v = 32'h05a05a0;
	if (addr == 14'h000)
	    v = requestFiredCount;
	if (addr == 14'h004)
	    v = outOfRangeWriteCount;

        slaveReadDataFifo.enq(v);
    endrule
    rule readWriteFifo if (slaveReadAddrFifo.first[14] == 0);
        slaveReadAddrFifo.deq;
        slaveReadDataFifo.enq(32'h05b05b0);
    endrule

    FromBit#(32,SetDmaHandle$Request) setDmaHandle$requestFifo <- mkFromBit();
    rule slaveWrite$setDmaHandle if (slaveWriteAddrFifo.first[14] == 0 && slaveWriteAddrFifo.first[13:8] == setDmaHandle$Offset);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        setDmaHandle$requestFifo.enq(slaveWriteDataFifo.first);
    endrule
    (* descending_urgency = "handle$setDmaHandle$request, handle$setDmaHandle$requestFailure" *)
    rule handle$setDmaHandle$request if (putEnable);
        let request = setDmaHandle$requestFifo.first;
        setDmaHandle$requestFifo.deq;
        ifc.setDmaHandle(request.hostHandle);
        requestFiredPulse.send();
    endrule
    rule handle$setDmaHandle$requestFailure;
        p.putFailed(0);
        setDmaHandle$requestFifo.deq;
        $display("setDmaHandle$requestFailure");
    endrule

    FromBit#(32,ReadPage$Request) readPage$requestFifo <- mkFromBit();
    rule slaveWrite$readPage if (slaveWriteAddrFifo.first[14] == 0 && slaveWriteAddrFifo.first[13:8] == readPage$Offset);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        readPage$requestFifo.enq(slaveWriteDataFifo.first);
    endrule
    (* descending_urgency = "handle$readPage$request, handle$readPage$requestFailure" *)
    rule handle$readPage$request if (putEnable);
        let request = readPage$requestFifo.first;
        readPage$requestFifo.deq;
        ifc.readPage(request.pageIdx, request.tag);
        requestFiredPulse.send();
    endrule
    rule handle$readPage$requestFailure;
        p.putFailed(1);
        readPage$requestFifo.deq;
        $display("readPage$requestFailure");
    endrule

    FromBit#(32,WritePage$Request) writePage$requestFifo <- mkFromBit();
    rule slaveWrite$writePage if (slaveWriteAddrFifo.first[14] == 0 && slaveWriteAddrFifo.first[13:8] == writePage$Offset);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        writePage$requestFifo.enq(slaveWriteDataFifo.first);
    endrule
    (* descending_urgency = "handle$writePage$request, handle$writePage$requestFailure" *)
    rule handle$writePage$request if (putEnable);
        let request = writePage$requestFifo.first;
        writePage$requestFifo.deq;
        ifc.writePage(request.pageIdx, request.tag);
        requestFiredPulse.send();
    endrule
    rule handle$writePage$requestFailure;
        p.putFailed(2);
        writePage$requestFifo.deq;
        $display("writePage$requestFailure");
    endrule

    FromBit#(32,ReadRawWord$Request) readRawWord$requestFifo <- mkFromBit();
    rule slaveWrite$readRawWord if (slaveWriteAddrFifo.first[14] == 0 && slaveWriteAddrFifo.first[13:8] == readRawWord$Offset);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        readRawWord$requestFifo.enq(slaveWriteDataFifo.first);
    endrule
    (* descending_urgency = "handle$readRawWord$request, handle$readRawWord$requestFailure" *)
    rule handle$readRawWord$request if (putEnable);
        let request = readRawWord$requestFifo.first;
        readRawWord$requestFifo.deq;
        ifc.readRawWord(request.data);
        requestFiredPulse.send();
    endrule
    rule handle$readRawWord$requestFailure;
        p.putFailed(3);
        readRawWord$requestFifo.deq;
        $display("readRawWord$requestFailure");
    endrule


    (* descending_urgency = "handle$setDmaHandle$requestFailure, handle$readPage$requestFailure, handle$writePage$requestFailure, handle$readRawWord$requestFailure"*)
    rule outOfRangeWrite if (slaveWriteAddrFifo.first[14] == 0 && 
                             slaveWriteAddrFifo.first[13:8] >= 4);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        outOfRangeWriteCount <= outOfRangeWriteCount+1;
    endrule


    interface StdPortal portalIfc;
    method Bit#(32) ifcId;
        return zeroExtend(pack(id));
    endmethod
    method Bit#(32) ifcType;
        return truncate(128'h487bd02a7940a95db386e4fa3a290b0b);
    endmethod
    interface MemSlave slave;
        interface MemWriteServer write_server;
            interface Put writeReq;
                method Action put(MemRequest#(16) req);
                     req_aw_fifo.enq(req);
                endmethod
            endinterface
            interface Put writeData;
                method Action put(ObjectData#(32) wdata);
                    let ws = slaveWS;
                    let wbc = slaveWriteBurstCountReg;
                    let wa = slaveWriteAddrReg;
                    let wid = slaveWriteTagReg;
                    if (slaveWriteBurstCountReg == 0) begin
                        let req = req_aw_fifo.first;
                        ws = req.addr[15];
                        wbc = req.burstLen;
                        wa = truncate(req.addr);
      	   	        wid = req.tag;
                        req_aw_fifo.deq;
                    end
                    let addr = wa;
                    slaveWriteAddrReg <= wa + 4;
                    slaveWriteBurstCountReg <= wbc - 1;
    
                    slaveWriteAddrFifos[ws].enq(wa[14:0]);
                    slaveWriteDataFifos[ws].enq(wdata.data);
    
                    if (wbc == 1)
                        slaveBrespFifo.enq(wdata.tag);
    
                    slaveWS <= ws;
                    slaveWriteTagReg <= wid;
                endmethod
            endinterface
            interface Get writeDone;
                method ActionValue#(Bit#(6)) get();
                    slaveBrespFifo.deq;
                    return slaveBrespFifo.first;
                endmethod
            endinterface
        endinterface
        interface MemReadServer read_server;
            interface Put readReq;
                method Action put(MemRequest#(16) req);
                    req_ar_fifo.enq(req);
                endmethod
            endinterface
            interface Get readData;
                method ActionValue#(ObjectData#(32)) get();
                    let info = slaveReadReqInfoFifo.first();
                    slaveReadReqInfoFifo.deq();
                    let v = slaveReadDataFifos[info.select].first;
                    slaveReadDataFifos[info.select].deq;
                    return ObjectData { data: v, tag: info.tag};
                endmethod
            endinterface
        endinterface
    endinterface
interface ReadOnly interrupt = p.interrupt;
    endinterface

endmodule
endpackage: InterfaceRequestWrapper
