package PlatformIndicationProxy;

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
import PlatformInterfaces::*;


typedef struct {
    Bit#(1) select;
    Bit#(6) tag;
} ReadReqInfo deriving (Bits);



typedef struct {
    Bit#(32) v;
} PutFailed$Request deriving (Bits);
Bit#(6) putFailed$Offset = 0;

// hidden wrapper interface
interface PlatformIndicationProxyStatus;
endinterface

// hidden wrapper implementation
module  mkPlatformIndicationProxyStatus#(FIFO#(Bit#(15)) slaveWriteAddrFifo,
                            FIFO#(Bit#(15)) slaveReadAddrFifo,
                            FIFO#(Bit#(32)) slaveWriteDataFifo,
                            FIFOF#(Bit#(32)) slaveReadDataFifo)(PlatformIndicationProxyStatus);

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
    Bit#(64) word;
} SendWord8$Response deriving (Bits);
Bit#(6) sendWord8$Offset = 0;

typedef struct {
    Bit#(32) word;
} SendWord4$Response deriving (Bits);
Bit#(6) sendWord4$Offset = 1;

typedef struct {
    Bit#(64) key;
} SendKey$Response deriving (Bits);
Bit#(6) sendKey$Offset = 2;

typedef struct {
    Bit#(64) data;
} RawWordTest$Response deriving (Bits);
Bit#(6) rawWordTest$Offset = 3;

typedef struct {
    Bit#(32) words;
} RequestWords$Response deriving (Bits);
Bit#(6) requestWords$Offset = 4;

// exposed proxy interface
interface PlatformIndicationProxy;
    interface StdPortal portalIfc;
    interface PlatformIndication ifc;
endinterface

(* synthesize *)
module  mkPlatformIndicationProxySynth#(Bit#(32) id) (PlatformIndicationProxy);

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
    PlatformIndicationProxyStatus p <- mkPlatformIndicationProxyStatus(slaveWriteAddrFifos[0],
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


    ToBit#(32,SendWord8$Response) sendWord8$responseFifo <- mkToBit();
    rule sendWord8$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == sendWord8$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (sendWord8$responseFifo.notEmpty) begin
            sendWord8$responseFifo.deq;
            v = sendWord8$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[sendWord8$Offset] = sendWord8$responseFifo.notEmpty;

    ToBit#(32,SendWord4$Response) sendWord4$responseFifo <- mkToBit();
    rule sendWord4$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == sendWord4$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (sendWord4$responseFifo.notEmpty) begin
            sendWord4$responseFifo.deq;
            v = sendWord4$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[sendWord4$Offset] = sendWord4$responseFifo.notEmpty;

    ToBit#(32,SendKey$Response) sendKey$responseFifo <- mkToBit();
    rule sendKey$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == sendKey$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (sendKey$responseFifo.notEmpty) begin
            sendKey$responseFifo.deq;
            v = sendKey$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[sendKey$Offset] = sendKey$responseFifo.notEmpty;

    ToBit#(32,RawWordTest$Response) rawWordTest$responseFifo <- mkToBit();
    rule rawWordTest$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == rawWordTest$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (rawWordTest$responseFifo.notEmpty) begin
            rawWordTest$responseFifo.deq;
            v = rawWordTest$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[rawWordTest$Offset] = rawWordTest$responseFifo.notEmpty;

    ToBit#(32,RequestWords$Response) requestWords$responseFifo <- mkToBit();
    rule requestWords$read if (slaveReadAddrFifo.first[14] == 0 && 
                                         slaveReadAddrFifo.first[13:8] == requestWords$Offset);
        slaveReadAddrFifo.deq;
        let v = 32'hbad0dada;
        if (requestWords$responseFifo.notEmpty) begin
            requestWords$responseFifo.deq;
            v = requestWords$responseFifo.first;
        end
        else begin
            underflowReadCountReg <= underflowReadCountReg + 1;
            $display("underflow");
        end
        slaveReadDataFifo.enq(v);
    endrule
    readyBits[requestWords$Offset] = requestWords$responseFifo.notEmpty;


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

    interface PlatformIndication ifc;

    method Action sendWord8(Bit#(64) word);
        sendWord8$responseFifo.enq(SendWord8$Response {word: word});
        //$display("indicationMethod 'sendWord8' invoked");
    endmethod
    method Action sendWord4(Bit#(32) word);
        sendWord4$responseFifo.enq(SendWord4$Response {word: word});
        //$display("indicationMethod 'sendWord4' invoked");
    endmethod
    method Action sendKey(Bit#(64) key);
        sendKey$responseFifo.enq(SendKey$Response {key: key});
        //$display("indicationMethod 'sendKey' invoked");
    endmethod
    method Action rawWordTest(Bit#(64) data);
        rawWordTest$responseFifo.enq(RawWordTest$Response {data: data});
        //$display("indicationMethod 'rawWordTest' invoked");
    endmethod
    method Action requestWords(Bit#(32) words);
        requestWords$responseFifo.enq(RequestWords$Response {words: words});
        //$display("indicationMethod 'requestWords' invoked");
    endmethod
    endinterface


    interface StdPortal portalIfc;
    method Bit#(32) ifcId;
        return zeroExtend(pack(id));
    endmethod
    method Bit#(32) ifcType;
        return truncate(128'h5f0691a66694d3077d03aad32cd523fb);
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
module  mkPlatformIndicationProxy#(idType id) (PlatformIndicationProxy) 
    provisos (Bits#(idType, __a), 
              Add#(a__, __a, 32));
    let rv <- mkPlatformIndicationProxySynth(extend(pack(id)));
    return rv;
endmodule
endpackage: PlatformIndicationProxy
