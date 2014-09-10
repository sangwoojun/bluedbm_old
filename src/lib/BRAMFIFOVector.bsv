import BRAM::*;
import FIFO::*;
import Vector::*;

interface BRAMFIFOVectorIfc#(numeric type vlog, numeric type fifosize, type fifotype);
	method Action enq(fifotype data, Bit#(vlog) idx);
	method Action deq(Bit#(vlog) idx);
	method ActionValue#(fifotype) first(Bit#(vlog) idx);
	method Bit#(11) dataCount(Bit#(vlog) idx);
	method ActionValue#(Bit#(vlog)) getReadyIdx;
endinterface

module mkBRAMFIFOVector#(Integer thresh) (BRAMFIFOVectorIfc#(vlog, fifosize, fifotype))
	provisos (
		Literal#(fifotype), 
		Bits#(fifotype, fifotypesz),
		Add#(a__, 11, TAdd#(vlog, TLog#(fifosize)))
		);

	BRAM2Port#(Bit#(TAdd#(vlog,TLog#(fifosize))), fifotype) fifoBuffer <- mkBRAM2Server(defaultValue); 

	Vector#(TExp#(vlog), Reg#(Bit#(11))) datacount <- replicateM(mkReg(0));
	Vector#(TExp#(vlog), Reg#(Bit#(11))) headpointer <- replicateM(mkReg(0));
	Vector#(TExp#(vlog), Reg#(Bit#(11))) tailpointer <- replicateM(mkReg(0));
	function Bool  isEmpty(Bit#(vlog) idx);
		Bool res = False;
		if ( headpointer[idx] == tailpointer[idx] ) res = True;
		if ( datacount[idx] == 0 ) res = True;

		return res;
	endfunction
	function Bool isFull(Bit#(vlog) idx);
		Bool res = False;
		Integer bufsize = valueOf(fifosize);
		let head1 = headpointer[idx]+1;
		if ( head1 >= fromInteger(bufsize) ) head1 = 0;

		if ( head1 == tailpointer[idx] ) res = True;
		if ( datacount[idx]+1 >= fromInteger(valueOf(fifosize)) ) res = True;
		return res;
	endfunction

	FIFO#(Bool) fakeQ0 <- mkFIFO;
	FIFO#(Bool) fakeQ1 <- mkFIFO;
	FIFO#(Bool) fakeQ2 <- mkFIFO;
	
	Vector#(TExp#(vlog), Reg#(Maybe#(fifotype))) deqV <- replicateM(mkReg(tagged Invalid));

	FIFO#(Bit#(vlog)) reqs <- mkFIFO;
	rule relayDeqV;
		let v <- fifoBuffer.portB.response.get();
		let idx = reqs.first;
		reqs.deq;
		//if ( idx > 0 ) $display ( "%d relaying", idx );

		if ( datacount[idx] > 0 ) begin
			deqV[idx] <= tagged Valid v;
		end
	endrule

	FIFO#(Bit#(vlog)) readyIdxQ <- mkSizedFIFO(32);
	
	method Action deq(Bit#(vlog) idx);
		if ( isEmpty( idx ) ) fakeQ1.deq;

		Integer bufsize = valueOf(fifosize);
		let tail1 = tailpointer[idx]+1;
		if ( tail1 >= fromInteger(bufsize) ) tail1 = 0;
		tailpointer[idx] <= tail1;

		deqV[idx] <= tagged Invalid;

		reqs.enq(idx);

		fifoBuffer.portB.request.put(
			BRAMRequest{
			write:False, 
			responseOnWrite:?, 
			address:zeroExtend(idx)*fromInteger(bufsize)+zeroExtend(tail1), 
			datain:?});

		datacount[idx] <= datacount[idx] - 1;
		
		//$display ("%d deqing from tail %d %d %d", idx, headpointer[idx], tail1, datacount[idx]-1);

	endmethod
	method Action enq(fifotype data, Bit#(vlog) idx); 
		if (isFull ( idx )) fakeQ0.deq;

		Integer bufsize = valueOf(fifosize);
		let head1 = headpointer[idx]+1;
		if ( head1 >= fromInteger(bufsize) ) head1 = 0;
		headpointer[idx] <= head1;

		//$display ("%d enqing to head %d %d %d", idx, head1, tailpointer[idx], datacount[idx]+1);

		fifoBuffer.portA.request.put(BRAMRequest{write:True, responseOnWrite:False, address:zeroExtend(idx)*fromInteger(bufsize)+zeroExtend(headpointer[idx]), datain:data});

		datacount[idx] <= datacount[idx] + 1;
		if ( isEmpty( idx ) ) begin
			deqV[idx] <= tagged Valid data;
		end

		if ( datacount[idx] + 1 >= fromInteger(thresh) ) begin
			readyIdxQ.enq(idx);
		end

	endmethod
	method ActionValue#(fifotype) first(Bit#(vlog) idx);
		if ( !isValid(deqV[idx]) ) fakeQ2.deq;  
		else if (isEmpty(idx)) fakeQ2.deq;

		return fromMaybe(0,deqV[idx]);
	endmethod
	method Bit#(11) dataCount(Bit#(vlog) idx);
		return datacount[idx];
	endmethod

	method ActionValue#(Bit#(vlog)) getReadyIdx;
		readyIdxQ.deq;
		return readyIdxQ.first;
	endmethod
endmodule
