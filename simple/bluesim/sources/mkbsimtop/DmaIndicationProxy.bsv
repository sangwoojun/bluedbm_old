package DmaIndicationProxy;

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
import PortalMemory::*;


typedef struct {
    Bit#(1) select;
    Bit#(6) tag;
} ReadReqInfo deriving (Bits);



typedef struct {
    Bit#(32) v;
} PutFailed$Request deriving (Bits);
Bit#(6) putFailed$Offset = 0;

// hidden wrapper interface
interface DmaIndicationProxyStatus;
endinterface

// hidden wrapper implementation
module  mkDmaIndicationProxyStatus#(FIFO#(Bit#(15)) slaveWriteAddrFifo,
                            FIFO#(Bit#(15)) slaveReadAddrFifo,
                            FIFO#(Bit#(32)) slaveWriteDataFifo,
                            FIFOF#(Bit#(32)) slaveReadDataFifo)(DmaIndicationProxyStatus);

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

    FromBit#(32,PutFailed$Request) putFailed$requestFifo <- mkFromBit();
    rule slaveWrite$putFailed if (slaveWriteAddrFifo.first[14] == 0 && slaveWriteAddrFifo.first[13:8] == putFailed$Offset);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        putFailed$requestFifo.enq(slaveWriteDataFifo.first);
    endrule
    (* descending_urgency = "handle$putFailed$request, handle$putFailed$requestFailure" *)
    rule handle$putFailed$request if (putEnable);
        let request = putFailed$requestFifo.first;
        putFailed$requestFifo.deq;
        
        requestFiredPulse.send();
    endrule
    rule handle$putFailed$requestFailure;
        
        putFailed$requestFifo.deq;
        $display("putFailed$requestFailure");
    endrule


    (* descending_urgency = "handle$putFailed$requestFailure"*)
    rule outOfRangeWrite if (slaveWriteAddrFifo.first[14] == 0 && 
                             slaveWriteAddrFifo.first[13:8] >= 1);
        slaveWriteAddrFifo.deq;
        slaveWriteDataFifo.deq;
        outOfRangeWriteCount <= outOfRangeWriteCount+1;
    endrule

endmodule


typedef struct {
    Bit#(32) pointer;
    Bit#(40) msg;
} ConfigResp$Response deriving (Bits);
Bit#(6) configResp$Offset = 0;

typedef struct {
    Bit#(64) physAddr;
} AddrResponse$Response deriving (Bits);
Bit#(6) addrResponse$Offset = 1;

typedef struct {
    Bit#(32) pointer;
} BadPointer$Response deriving (Bits);
Bit#(6) badPointer$Offset = 2;

typedef struct {
    Bit#(32) pointer;
    Bit#(64) offset;
    Bit#(40) barrier;
} BadAddrTrans$Response deriving (Bits);
Bit#(6) badAddrTrans$Offset = 3;

typedef struct {
    Bit#(32) pointer;
    Bit#(32) sz;
} BadPageSize$Response deriving (Bits);
Bit#(6) badPageSize$Offset = 4;

typedef struct {
    Bit#(32) pointer;
    Bit#(32) sz;
} BadNumberEntries$Response deriving (Bits);
Bit#(6) badNumberEntries$Offset = 5;

typedef struct {
    Bit#(32) pointer;
    Bit#(40) offset;
    Bit#(64) physAddr;
} BadAddr$Response deriving (Bits);
Bit#(6) badAddr$Offset = 6;

typedef struct {
    DmaDbgRec rec;
} ReportStateDbg$Response deriving (Bits);
Bit#(6) reportStateDbg$Offset = 7;

typedef struct {
    Bit#(64) words;
} ReportMemoryTraffic$Response deriving (Bits);
Bit#(6) reportMemoryTraffic$Offset = 8;

typedef struct {
    ChannelType x;
    Bit#(32) a;
    Bit#(32) b;
} TagMismatch$Response deriving (Bits);
Bit#(6) tagMismatch$Offset = 9;

// exposed proxy interface
interface DmaIndicationProxy;
    interface StdPortal portalIfc;
    interface DmaIndication ifc;
endinterface

(* synthesize *)
module  mkDmaIndicationProxySynth#(Bit#(32) id) (DmaIndicationProxy);

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

    let slaveWriteAddrFifo = slaveWriteAddrFifos[1];
    let slaveReadAddrFifo  = slaveReadAddrFifos[1];
    let slaveWriteDataFifo = slaveWriteDataFifos[1];
    let slaveReadDataFifo  = slaveReadDataFifos[1];

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

    // instantiate hidden wrapper to receive failure notifications
    DmaIndicationProxyStatus p <- mkDmaIndicationProxyStatus(slaveWriteAddrFifos[0],
                                           slaveReadAddrFifos[0],
                                           slaveWriteDataFifos[0],
                                           slaveReadDataFifos[0]);

    // indication-specific state
    Reg#(Bit#(32)) underflowReadCountReg <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeReadCountReg <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeWriteCount <- mkReg(0);
    Vector#(10, Bool) readyBits = replicate(False);

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


    ToBit#(32,ConfigResp$Response) configResp$responseFifo <- mkToBit();
    rule configResp$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == configResp$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (configResp$responseFifo.notEmpty) begin
            configResp$responseFifo.deq;
            v = configResp$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[configResp$Offset] = configResp$responseFifo.notEmpty;

    ToBit#(32,AddrResponse$Response) addrResponse$responseFifo <- mkToBit();
    rule addrResponse$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == addrResponse$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (addrResponse$responseFifo.notEmpty) begin
            addrResponse$responseFifo.deq;
            v = addrResponse$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[addrResponse$Offset] = addrResponse$responseFifo.notEmpty;

    ToBit#(32,BadPointer$Response) badPointer$responseFifo <- mkToBit();
    rule badPointer$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == badPointer$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (badPointer$responseFifo.notEmpty) begin
            badPointer$responseFifo.deq;
            v = badPointer$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[badPointer$Offset] = badPointer$responseFifo.notEmpty;

    ToBit#(32,BadAddrTrans$Response) badAddrTrans$responseFifo <- mkToBit();
    rule badAddrTrans$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == badAddrTrans$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (badAddrTrans$responseFifo.notEmpty) begin
            badAddrTrans$responseFifo.deq;
            v = badAddrTrans$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[badAddrTrans$Offset] = badAddrTrans$responseFifo.notEmpty;

    ToBit#(32,BadPageSize$Response) badPageSize$responseFifo <- mkToBit();
    rule badPageSize$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == badPageSize$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (badPageSize$responseFifo.notEmpty) begin
            badPageSize$responseFifo.deq;
            v = badPageSize$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[badPageSize$Offset] = badPageSize$responseFifo.notEmpty;

    ToBit#(32,BadNumberEntries$Response) badNumberEntries$responseFifo <- mkToBit();
    rule badNumberEntries$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == badNumberEntries$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (badNumberEntries$responseFifo.notEmpty) begin
            badNumberEntries$responseFifo.deq;
            v = badNumberEntries$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[badNumberEntries$Offset] = badNumberEntries$responseFifo.notEmpty;

    ToBit#(32,BadAddr$Response) badAddr$responseFifo <- mkToBit();
    rule badAddr$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == badAddr$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (badAddr$responseFifo.notEmpty) begin
            badAddr$responseFifo.deq;
            v = badAddr$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[badAddr$Offset] = badAddr$responseFifo.notEmpty;

    ToBit#(32,ReportStateDbg$Response) reportStateDbg$responseFifo <- mkToBit();
    rule reportStateDbg$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == reportStateDbg$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (reportStateDbg$responseFifo.notEmpty) begin
            reportStateDbg$responseFifo.deq;
            v = reportStateDbg$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[reportStateDbg$Offset] = reportStateDbg$responseFifo.notEmpty;

    ToBit#(32,ReportMemoryTraffic$Response) reportMemoryTraffic$responseFifo <- mkToBit();
    rule reportMemoryTraffic$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == reportMemoryTraffic$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (reportMemoryTraffic$responseFifo.notEmpty) begin
            reportMemoryTraffic$responseFifo.deq;
            v = reportMemoryTraffic$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[reportMemoryTraffic$Offset] = reportMemoryTraffic$responseFifo.notEmpty;

    ToBit#(32,TagMismatch$Response) tagMismatch$responseFifo <- mkToBit();
    rule tagMismatch$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == tagMismatch$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (tagMismatch$responseFifo.notEmpty) begin
            tagMismatch$responseFifo.deq;
            v = tagMismatch$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[tagMismatch$Offset] = tagMismatch$responseFifo.notEmpty;


    Bool      interruptStatus = False;
    Bit#(32)  readyChannel = -1;
    for (Integer i = 0; i < 10; i = i + 1) begin
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
	    v = 10;
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
                            slaveReadAddrFifo.first[13:8] >= 10);
        slaveReadAddrFifo.deq;
        slaveReadDataFifo.enq(0);
        outOfRangeReadCountReg <= outOfRangeReadCountReg+1;
    endrule

    interface DmaIndication ifc;

    method Action configResp(Bit#(32) pointer, Bit#(40) msg);
        configResp$responseFifo.enq(ConfigResp$Response {pointer: pointer, msg: msg});
        //$display("indicationMethod 'configResp' invoked");
    endmethod
    method Action addrResponse(Bit#(64) physAddr);
        addrResponse$responseFifo.enq(AddrResponse$Response {physAddr: physAddr});
        //$display("indicationMethod 'addrResponse' invoked");
    endmethod
    method Action badPointer(Bit#(32) pointer);
        badPointer$responseFifo.enq(BadPointer$Response {pointer: pointer});
        //$display("indicationMethod 'badPointer' invoked");
    endmethod
    method Action badAddrTrans(Bit#(32) pointer, Bit#(64) offset, Bit#(40) barrier);
        badAddrTrans$responseFifo.enq(BadAddrTrans$Response {pointer: pointer, offset: offset, barrier: barrier});
        //$display("indicationMethod 'badAddrTrans' invoked");
    endmethod
    method Action badPageSize(Bit#(32) pointer, Bit#(32) sz);
        badPageSize$responseFifo.enq(BadPageSize$Response {pointer: pointer, sz: sz});
        //$display("indicationMethod 'badPageSize' invoked");
    endmethod
    method Action badNumberEntries(Bit#(32) pointer, Bit#(32) sz);
        badNumberEntries$responseFifo.enq(BadNumberEntries$Response {pointer: pointer, sz: sz});
        //$display("indicationMethod 'badNumberEntries' invoked");
    endmethod
    method Action badAddr(Bit#(32) pointer, Bit#(40) offset, Bit#(64) physAddr);
        badAddr$responseFifo.enq(BadAddr$Response {pointer: pointer, offset: offset, physAddr: physAddr});
        //$display("indicationMethod 'badAddr' invoked");
    endmethod
    method Action reportStateDbg(DmaDbgRec rec);
        reportStateDbg$responseFifo.enq(ReportStateDbg$Response {rec: rec});
        //$display("indicationMethod 'reportStateDbg' invoked");
    endmethod
    method Action reportMemoryTraffic(Bit#(64) words);
        reportMemoryTraffic$responseFifo.enq(ReportMemoryTraffic$Response {words: words});
        //$display("indicationMethod 'reportMemoryTraffic' invoked");
    endmethod
    method Action tagMismatch(ChannelType x, Bit#(32) a, Bit#(32) b);
        tagMismatch$responseFifo.enq(TagMismatch$Response {x: x, a: a, b: b});
        //$display("indicationMethod 'tagMismatch' invoked");
    endmethod
    endinterface


    interface StdPortal portalIfc;
    method Bit#(32) ifcId;
        return zeroExtend(pack(id));
    endmethod
    method Bit#(32) ifcType;
        return truncate(128'h763a0d8943c25f2e6d8391c1c8ecbbbd);
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

    interface ReadOnly interrupt;
        method Bool _read();
            return (interruptEnableReg && interruptStatus);
        endmethod
    endinterface

    endinterface

endmodule

// exposed proxy implementation
module  mkDmaIndicationProxy#(idType id) (DmaIndicationProxy) 
    provisos (Bits#(idType, __a), 
              Add#(a__, __a, 32));
    let rv <- mkDmaIndicationProxySynth(extend(pack(id)));
    return rv;
endmodule
endpackage: DmaIndicationProxy
