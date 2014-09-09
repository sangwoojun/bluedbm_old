package InterfaceIndicationProxy;

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
} PutFailed$Request deriving (Bits);
Bit#(6) putFailed$Offset = 0;

// hidden wrapper interface
interface InterfaceIndicationProxyStatus;
endinterface

// hidden wrapper implementation
module  mkInterfaceIndicationProxyStatus#(FIFO#(Bit#(15)) slaveWriteAddrFifo,
                            FIFO#(Bit#(15)) slaveReadAddrFifo,
                            FIFO#(Bit#(32)) slaveWriteDataFifo,
                            FIFOF#(Bit#(32)) slaveReadDataFifo)(InterfaceIndicationProxyStatus);

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
    Bit#(32) tag;
} PageReadDone$Response deriving (Bits);
Bit#(6) pageReadDone$Offset = 0;

typedef struct {
    Bit#(32) tag;
} PageWriteDone$Response deriving (Bits);
Bit#(6) pageWriteDone$Offset = 1;

typedef struct {
    Bit#(32) tag;
} PageWriteFail$Response deriving (Bits);
Bit#(6) pageWriteFail$Offset = 2;

typedef struct {
    Bit#(32) a;
    Bit#(32) b;
} Hexdump$Response deriving (Bits);
Bit#(6) hexdump$Offset = 3;

typedef struct {
    Bit#(64) data;
} WriteRawWord$Response deriving (Bits);
Bit#(6) writeRawWord$Offset = 4;

// exposed proxy interface
interface InterfaceIndicationProxy;
    interface StdPortal portalIfc;
    interface InterfaceIndication ifc;
endinterface

(* synthesize *)
module  mkInterfaceIndicationProxySynth#(Bit#(32) id) (InterfaceIndicationProxy);

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
    InterfaceIndicationProxyStatus p <- mkInterfaceIndicationProxyStatus(slaveWriteAddrFifos[0],
                                           slaveReadAddrFifos[0],
                                           slaveWriteDataFifos[0],
                                           slaveReadDataFifos[0]);

    // indication-specific state
    Reg#(Bit#(32)) underflowReadCountReg <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeReadCountReg <- mkReg(0);
    Reg#(Bit#(32)) outOfRangeWriteCount <- mkReg(0);
    Vector#(5, Bool) readyBits = replicate(False);

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


    ToBit#(32,PageReadDone$Response) pageReadDone$responseFifo <- mkToBit();
    rule pageReadDone$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == pageReadDone$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (pageReadDone$responseFifo.notEmpty) begin
            pageReadDone$responseFifo.deq;
            v = pageReadDone$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[pageReadDone$Offset] = pageReadDone$responseFifo.notEmpty;

    ToBit#(32,PageWriteDone$Response) pageWriteDone$responseFifo <- mkToBit();
    rule pageWriteDone$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == pageWriteDone$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (pageWriteDone$responseFifo.notEmpty) begin
            pageWriteDone$responseFifo.deq;
            v = pageWriteDone$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[pageWriteDone$Offset] = pageWriteDone$responseFifo.notEmpty;

    ToBit#(32,PageWriteFail$Response) pageWriteFail$responseFifo <- mkToBit();
    rule pageWriteFail$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == pageWriteFail$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (pageWriteFail$responseFifo.notEmpty) begin
            pageWriteFail$responseFifo.deq;
            v = pageWriteFail$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[pageWriteFail$Offset] = pageWriteFail$responseFifo.notEmpty;

    ToBit#(32,Hexdump$Response) hexdump$responseFifo <- mkToBit();
    rule hexdump$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == hexdump$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (hexdump$responseFifo.notEmpty) begin
            hexdump$responseFifo.deq;
            v = hexdump$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[hexdump$Offset] = hexdump$responseFifo.notEmpty;

    ToBit#(32,WriteRawWord$Response) writeRawWord$responseFifo <- mkToBit();
    rule writeRawWord$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == writeRawWord$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (writeRawWord$responseFifo.notEmpty) begin
            writeRawWord$responseFifo.deq;
            v = writeRawWord$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[writeRawWord$Offset] = writeRawWord$responseFifo.notEmpty;


    Bool      interruptStatus = False;
    Bit#(32)  readyChannel = -1;
    for (Integer i = 0; i < 5; i = i + 1) begin
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
	    v = 5;
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
                            slaveReadAddrFifo.first[13:8] >= 5);
        slaveReadAddrFifo.deq;
        slaveReadDataFifo.enq(0);
        outOfRangeReadCountReg <= outOfRangeReadCountReg+1;
    endrule

    interface InterfaceIndication ifc;

    method Action pageReadDone(Bit#(32) tag);
        pageReadDone$responseFifo.enq(PageReadDone$Response {tag: tag});
        //$display("indicationMethod 'pageReadDone' invoked");
    endmethod
    method Action pageWriteDone(Bit#(32) tag);
        pageWriteDone$responseFifo.enq(PageWriteDone$Response {tag: tag});
        //$display("indicationMethod 'pageWriteDone' invoked");
    endmethod
    method Action pageWriteFail(Bit#(32) tag);
        pageWriteFail$responseFifo.enq(PageWriteFail$Response {tag: tag});
        //$display("indicationMethod 'pageWriteFail' invoked");
    endmethod
    method Action hexdump(Bit#(32) a, Bit#(32) b);
        hexdump$responseFifo.enq(Hexdump$Response {a: a, b: b});
        //$display("indicationMethod 'hexdump' invoked");
    endmethod
    method Action writeRawWord(Bit#(64) data);
        writeRawWord$responseFifo.enq(WriteRawWord$Response {data: data});
        //$display("indicationMethod 'writeRawWord' invoked");
    endmethod
    endinterface


    interface StdPortal portalIfc;
    method Bit#(32) ifcId;
        return zeroExtend(pack(id));
    endmethod
    method Bit#(32) ifcType;
        return truncate(128'hd5f697744bfe9d76923a0f8c6ece5e9f);
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
module  mkInterfaceIndicationProxy#(idType id) (InterfaceIndicationProxy) 
    provisos (Bits#(idType, __a), 
              Add#(a__, __a, 32));
    let rv <- mkInterfaceIndicationProxySynth(extend(pack(id)));
    return rv;
endmodule
endpackage: InterfaceIndicationProxy
