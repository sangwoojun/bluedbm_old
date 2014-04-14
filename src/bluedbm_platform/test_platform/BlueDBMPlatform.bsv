import FIFO::*;
import Interface::*;
import DRAMController::*;

import PageCache::*;

interface BlueDBMPlatformIfc;
	method Action readPage(Bit#(64) pageIdx);
endinterface

module mkBlueDBMPlatform#(FlashIfc flash, BlueDBMHostIfc host, DRAMControllerIfc dram)
	(BlueDBMPlatformIfc);
	
	/*
	Reg#(Bit#(32)) repeatCount <- mkReg(0);
	Reg#(Bit#(32)) tempHandle <- mkReg(0);
	rule getCommand;
		if ( repeatCount == 0 ) begin
			let cmd <- host.readPage;
			tempHandle <= cmd.handle;
			repeatCount <= 512;//truncate(cmd.pageIdx);
		end else begin
		//if ( cmd.cmd == Cmd_ReadPage ) begin
			flash.command(BlueDBMCommand {
				cmd:Cmd_ReadPage,
				pageIdx:zeroExtend(repeatCount), tag: zeroExtend(repeatCount[5:0]),
				handle:tempHandle
			});
			repeatCount <= repeatCount - 1;
		end
	endrule
	*/

	Reg#(Bit#(64)) dramTestCounter <- mkReg(0);
	rule writeMem;
		Bit#(64) d <- host.getRawWord;

		Bit#(512) wd = extend({
			dramTestCounter,
			dramTestCounter,
			64'hcafef00db00bd00d,
			dramTestCounter,
			64'hdeadbeef,
			dramTestCounter,
			64'hcafed00d,
			dramTestCounter});
		dram.write(d, wd, 64);
		dramTestCounter <= dramTestCounter + 1;
		//host.putRawWord({32'hcafecafe,dramTestCounter[31:0]});
	endrule
	rule readMem ( dramTestCounter >= 128 && dramTestCounter < 256 );
		dram.readReq((dramTestCounter-128)*64, 64);
		dramTestCounter <= dramTestCounter + 1;
	endrule
	FIFO#(Bit#(512)) dumpQ <- mkSizedFIFO(4);
	rule getRead ;
		let dr <- dram.read;
		dumpQ.enq(dr);
	endrule

	Reg#(Bit#(512)) rdata <- mkReg(0);
	Reg#(Bit#(32)) rcount <- mkReg(0);
	rule flushDump;
		if ( rcount == 0 ) begin
			dumpQ.deq;
			let t = dumpQ.first;
			rdata <= t>>64;
			rcount <= 7;
			host.putRawWord(truncate(t));
		end
		else begin
			rcount <= rcount - 1;
			rdata <= rdata>>64;
			host.putRawWord(truncate(rdata));
		end

		//host.hexdump(tpl_1(t), tpl_2(t));
	endrule

	PageCacheIfc pageCache <- mkPageCache();

	rule getCommand;
		let cmd <- host.getCommand;
		if ( cmd.cmd == Cmd_ReadPage ) begin
			pageCache.readPage(cmd.pageIdx, truncate(cmd.tag));
		/*
			flash.command(BlueDBMCommand {
				cmd:Cmd_ReadPage,
				pageIdx:cmd.pageIdx, tag:cmd.tag
			});
			*/

			//host.writeBackPage(cmd.tag);
		end else 
		if ( cmd.cmd == Cmd_WritePage ) begin
			host.readPage(truncate(cmd.tag));
			pageCache.writePage(cmd.pageIdx, truncate(cmd.tag));
		end
	endrule

	rule flushRead;
		//let q <- flash.readWord;
		let q <- pageCache.readWord;
		// do processing
		// flash.returnPage
		host.writeWord(tpl_1(q), tpl_2(q));
	endrule

	Reg#(Bit#(64)) counter <- mkReg(0);
	rule flushWrite;
		let q <- host.readWord;
		//pageCache.writeWord(counter, tpl_2(q));
		counter <= counter + 1;
		pageCache.writeWord(tpl_1(q), tpl_2(q));
	endrule

	method Action readPage(Bit#(64) pageIdx);
	endmethod
endmodule
