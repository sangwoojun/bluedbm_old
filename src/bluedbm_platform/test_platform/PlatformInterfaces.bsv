interface PlatformIndication;
	method Action rawWordTest(Bit#(64) data);
endinterface

interface PlatformRequest;
	method Action rawWordRequest(Bit#(64) data);
endinterface
