package Platform;

import FIFO::*;
import Clocks::*;

import AuroraImportArtix7 :: *;
import I2CSimple::*;

interface ControllerPlatformIfc;
endinterface

module mkPlatform#(AuroraIfc aurora0, Clock clk100, Reset rst100) 
	(ControllerPlatformIfc);

	Reg#(Bit#(32)) auroraDummy <- mkReg(0);
	Reg#(Bit#(1)) auroraStat <- mkReg(0);

	FIFO#(DataIfc) auroraRQ <- mkFIFO();
	rule sendMAuroraR;
		let d = auroraRQ.first;
		auroraRQ.deq;
		aurora0.send(d);
	endrule
	rule mirrorAuroraR;
		let d <- aurora0.receive;
		aurora0.send(d);
		//auroraRQ.enq(d);
	endrule

endmodule

endpackage: Platform
