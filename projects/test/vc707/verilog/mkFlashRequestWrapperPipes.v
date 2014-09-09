//
// Generated by Bluespec Compiler, version 2014.03.beta2 (build 33633, 2014-03-26)
//
// On Tue Sep  9 02:14:27 EDT 2014
//
//
// Ports:
// Name                         I/O  size props
// RDY_inputPipes_0_enq           O     1
// inputPipes_0_notFull           O     1 reg
// RDY_inputPipes_0_notFull       O     1 const
// RDY_inputPipes_1_enq           O     1
// inputPipes_1_notFull           O     1 reg
// RDY_inputPipes_1_notFull       O     1 const
// RDY_inputPipes_2_enq           O     1
// inputPipes_2_notFull           O     1 reg
// RDY_inputPipes_2_notFull       O     1 const
// RDY_inputPipes_3_enq           O     1 reg
// inputPipes_3_notFull           O     1 reg
// RDY_inputPipes_3_notFull       O     1 const
// RDY_inputPipes_4_enq           O     1
// inputPipes_4_notFull           O     1 reg
// RDY_inputPipes_4_notFull       O     1 const
// RDY_inputPipes_5_enq           O     1
// inputPipes_5_notFull           O     1 reg
// RDY_inputPipes_5_notFull       O     1 const
// requestSizeBits                O   192 const
// RDY_requestSizeBits            O     1 const
// startCopy_PipeOut_first        O   160 reg
// RDY_startCopy_PipeOut_first    O     1 reg
// RDY_startCopy_PipeOut_deq      O     1 reg
// startCopy_PipeOut_notEmpty     O     1 reg
// RDY_startCopy_PipeOut_notEmpty  O     1 const
// readPage_PipeOut_first         O   160 reg
// RDY_readPage_PipeOut_first     O     1 reg
// RDY_readPage_PipeOut_deq       O     1 reg
// readPage_PipeOut_notEmpty      O     1 reg
// RDY_readPage_PipeOut_notEmpty  O     1 const
// writePage_PipeOut_first        O   160 reg
// RDY_writePage_PipeOut_first    O     1 reg
// RDY_writePage_PipeOut_deq      O     1 reg
// writePage_PipeOut_notEmpty     O     1 reg
// RDY_writePage_PipeOut_notEmpty  O     1 const
// sendTest_PipeOut_first         O    32 reg
// RDY_sendTest_PipeOut_first     O     1 reg
// RDY_sendTest_PipeOut_deq       O     1 reg
// sendTest_PipeOut_notEmpty      O     1 reg
// RDY_sendTest_PipeOut_notEmpty  O     1 const
// addWriteHostBuffer_PipeOut_first  O    64 reg
// RDY_addWriteHostBuffer_PipeOut_first  O     1 reg
// RDY_addWriteHostBuffer_PipeOut_deq  O     1 reg
// addWriteHostBuffer_PipeOut_notEmpty  O     1 reg
// RDY_addWriteHostBuffer_PipeOut_notEmpty  O     1 const
// addReadHostBuffer_PipeOut_first  O    64 reg
// RDY_addReadHostBuffer_PipeOut_first  O     1 reg
// RDY_addReadHostBuffer_PipeOut_deq  O     1 reg
// addReadHostBuffer_PipeOut_notEmpty  O     1 reg
// RDY_addReadHostBuffer_PipeOut_notEmpty  O     1 const
// id                             I    32 unused
// CLK                            I     1 clock
// RST_N                          I     1 reset
// inputPipes_0_enq_v             I    32 reg
// inputPipes_1_enq_v             I    32 reg
// inputPipes_2_enq_v             I    32 reg
// inputPipes_3_enq_v             I    32 reg
// inputPipes_4_enq_v             I    32 reg
// inputPipes_5_enq_v             I    32 reg
// EN_inputPipes_0_enq            I     1
// EN_inputPipes_1_enq            I     1
// EN_inputPipes_2_enq            I     1
// EN_inputPipes_3_enq            I     1
// EN_inputPipes_4_enq            I     1
// EN_inputPipes_5_enq            I     1
// EN_startCopy_PipeOut_deq       I     1
// EN_readPage_PipeOut_deq        I     1
// EN_writePage_PipeOut_deq       I     1
// EN_sendTest_PipeOut_deq        I     1
// EN_addWriteHostBuffer_PipeOut_deq  I     1
// EN_addReadHostBuffer_PipeOut_deq  I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkFlashRequestWrapperPipes(id,
				  CLK,
				  RST_N,

				  inputPipes_0_enq_v,
				  EN_inputPipes_0_enq,
				  RDY_inputPipes_0_enq,

				  inputPipes_0_notFull,
				  RDY_inputPipes_0_notFull,

				  inputPipes_1_enq_v,
				  EN_inputPipes_1_enq,
				  RDY_inputPipes_1_enq,

				  inputPipes_1_notFull,
				  RDY_inputPipes_1_notFull,

				  inputPipes_2_enq_v,
				  EN_inputPipes_2_enq,
				  RDY_inputPipes_2_enq,

				  inputPipes_2_notFull,
				  RDY_inputPipes_2_notFull,

				  inputPipes_3_enq_v,
				  EN_inputPipes_3_enq,
				  RDY_inputPipes_3_enq,

				  inputPipes_3_notFull,
				  RDY_inputPipes_3_notFull,

				  inputPipes_4_enq_v,
				  EN_inputPipes_4_enq,
				  RDY_inputPipes_4_enq,

				  inputPipes_4_notFull,
				  RDY_inputPipes_4_notFull,

				  inputPipes_5_enq_v,
				  EN_inputPipes_5_enq,
				  RDY_inputPipes_5_enq,

				  inputPipes_5_notFull,
				  RDY_inputPipes_5_notFull,

				  requestSizeBits,
				  RDY_requestSizeBits,

				  startCopy_PipeOut_first,
				  RDY_startCopy_PipeOut_first,

				  EN_startCopy_PipeOut_deq,
				  RDY_startCopy_PipeOut_deq,

				  startCopy_PipeOut_notEmpty,
				  RDY_startCopy_PipeOut_notEmpty,

				  readPage_PipeOut_first,
				  RDY_readPage_PipeOut_first,

				  EN_readPage_PipeOut_deq,
				  RDY_readPage_PipeOut_deq,

				  readPage_PipeOut_notEmpty,
				  RDY_readPage_PipeOut_notEmpty,

				  writePage_PipeOut_first,
				  RDY_writePage_PipeOut_first,

				  EN_writePage_PipeOut_deq,
				  RDY_writePage_PipeOut_deq,

				  writePage_PipeOut_notEmpty,
				  RDY_writePage_PipeOut_notEmpty,

				  sendTest_PipeOut_first,
				  RDY_sendTest_PipeOut_first,

				  EN_sendTest_PipeOut_deq,
				  RDY_sendTest_PipeOut_deq,

				  sendTest_PipeOut_notEmpty,
				  RDY_sendTest_PipeOut_notEmpty,

				  addWriteHostBuffer_PipeOut_first,
				  RDY_addWriteHostBuffer_PipeOut_first,

				  EN_addWriteHostBuffer_PipeOut_deq,
				  RDY_addWriteHostBuffer_PipeOut_deq,

				  addWriteHostBuffer_PipeOut_notEmpty,
				  RDY_addWriteHostBuffer_PipeOut_notEmpty,

				  addReadHostBuffer_PipeOut_first,
				  RDY_addReadHostBuffer_PipeOut_first,

				  EN_addReadHostBuffer_PipeOut_deq,
				  RDY_addReadHostBuffer_PipeOut_deq,

				  addReadHostBuffer_PipeOut_notEmpty,
				  RDY_addReadHostBuffer_PipeOut_notEmpty);
  input  [31 : 0] id;
  input  CLK;
  input  RST_N;

  // action method inputPipes_0_enq
  input  [31 : 0] inputPipes_0_enq_v;
  input  EN_inputPipes_0_enq;
  output RDY_inputPipes_0_enq;

  // value method inputPipes_0_notFull
  output inputPipes_0_notFull;
  output RDY_inputPipes_0_notFull;

  // action method inputPipes_1_enq
  input  [31 : 0] inputPipes_1_enq_v;
  input  EN_inputPipes_1_enq;
  output RDY_inputPipes_1_enq;

  // value method inputPipes_1_notFull
  output inputPipes_1_notFull;
  output RDY_inputPipes_1_notFull;

  // action method inputPipes_2_enq
  input  [31 : 0] inputPipes_2_enq_v;
  input  EN_inputPipes_2_enq;
  output RDY_inputPipes_2_enq;

  // value method inputPipes_2_notFull
  output inputPipes_2_notFull;
  output RDY_inputPipes_2_notFull;

  // action method inputPipes_3_enq
  input  [31 : 0] inputPipes_3_enq_v;
  input  EN_inputPipes_3_enq;
  output RDY_inputPipes_3_enq;

  // value method inputPipes_3_notFull
  output inputPipes_3_notFull;
  output RDY_inputPipes_3_notFull;

  // action method inputPipes_4_enq
  input  [31 : 0] inputPipes_4_enq_v;
  input  EN_inputPipes_4_enq;
  output RDY_inputPipes_4_enq;

  // value method inputPipes_4_notFull
  output inputPipes_4_notFull;
  output RDY_inputPipes_4_notFull;

  // action method inputPipes_5_enq
  input  [31 : 0] inputPipes_5_enq_v;
  input  EN_inputPipes_5_enq;
  output RDY_inputPipes_5_enq;

  // value method inputPipes_5_notFull
  output inputPipes_5_notFull;
  output RDY_inputPipes_5_notFull;

  // value method requestSizeBits
  output [191 : 0] requestSizeBits;
  output RDY_requestSizeBits;

  // value method startCopy_PipeOut_first
  output [159 : 0] startCopy_PipeOut_first;
  output RDY_startCopy_PipeOut_first;

  // action method startCopy_PipeOut_deq
  input  EN_startCopy_PipeOut_deq;
  output RDY_startCopy_PipeOut_deq;

  // value method startCopy_PipeOut_notEmpty
  output startCopy_PipeOut_notEmpty;
  output RDY_startCopy_PipeOut_notEmpty;

  // value method readPage_PipeOut_first
  output [159 : 0] readPage_PipeOut_first;
  output RDY_readPage_PipeOut_first;

  // action method readPage_PipeOut_deq
  input  EN_readPage_PipeOut_deq;
  output RDY_readPage_PipeOut_deq;

  // value method readPage_PipeOut_notEmpty
  output readPage_PipeOut_notEmpty;
  output RDY_readPage_PipeOut_notEmpty;

  // value method writePage_PipeOut_first
  output [159 : 0] writePage_PipeOut_first;
  output RDY_writePage_PipeOut_first;

  // action method writePage_PipeOut_deq
  input  EN_writePage_PipeOut_deq;
  output RDY_writePage_PipeOut_deq;

  // value method writePage_PipeOut_notEmpty
  output writePage_PipeOut_notEmpty;
  output RDY_writePage_PipeOut_notEmpty;

  // value method sendTest_PipeOut_first
  output [31 : 0] sendTest_PipeOut_first;
  output RDY_sendTest_PipeOut_first;

  // action method sendTest_PipeOut_deq
  input  EN_sendTest_PipeOut_deq;
  output RDY_sendTest_PipeOut_deq;

  // value method sendTest_PipeOut_notEmpty
  output sendTest_PipeOut_notEmpty;
  output RDY_sendTest_PipeOut_notEmpty;

  // value method addWriteHostBuffer_PipeOut_first
  output [63 : 0] addWriteHostBuffer_PipeOut_first;
  output RDY_addWriteHostBuffer_PipeOut_first;

  // action method addWriteHostBuffer_PipeOut_deq
  input  EN_addWriteHostBuffer_PipeOut_deq;
  output RDY_addWriteHostBuffer_PipeOut_deq;

  // value method addWriteHostBuffer_PipeOut_notEmpty
  output addWriteHostBuffer_PipeOut_notEmpty;
  output RDY_addWriteHostBuffer_PipeOut_notEmpty;

  // value method addReadHostBuffer_PipeOut_first
  output [63 : 0] addReadHostBuffer_PipeOut_first;
  output RDY_addReadHostBuffer_PipeOut_first;

  // action method addReadHostBuffer_PipeOut_deq
  input  EN_addReadHostBuffer_PipeOut_deq;
  output RDY_addReadHostBuffer_PipeOut_deq;

  // value method addReadHostBuffer_PipeOut_notEmpty
  output addReadHostBuffer_PipeOut_notEmpty;
  output RDY_addReadHostBuffer_PipeOut_notEmpty;

  // signals for module outputs
  wire [191 : 0] requestSizeBits;
  wire [159 : 0] readPage_PipeOut_first,
		 startCopy_PipeOut_first,
		 writePage_PipeOut_first;
  wire [63 : 0] addReadHostBuffer_PipeOut_first,
		addWriteHostBuffer_PipeOut_first;
  wire [31 : 0] sendTest_PipeOut_first;
  wire RDY_addReadHostBuffer_PipeOut_deq,
       RDY_addReadHostBuffer_PipeOut_first,
       RDY_addReadHostBuffer_PipeOut_notEmpty,
       RDY_addWriteHostBuffer_PipeOut_deq,
       RDY_addWriteHostBuffer_PipeOut_first,
       RDY_addWriteHostBuffer_PipeOut_notEmpty,
       RDY_inputPipes_0_enq,
       RDY_inputPipes_0_notFull,
       RDY_inputPipes_1_enq,
       RDY_inputPipes_1_notFull,
       RDY_inputPipes_2_enq,
       RDY_inputPipes_2_notFull,
       RDY_inputPipes_3_enq,
       RDY_inputPipes_3_notFull,
       RDY_inputPipes_4_enq,
       RDY_inputPipes_4_notFull,
       RDY_inputPipes_5_enq,
       RDY_inputPipes_5_notFull,
       RDY_readPage_PipeOut_deq,
       RDY_readPage_PipeOut_first,
       RDY_readPage_PipeOut_notEmpty,
       RDY_requestSizeBits,
       RDY_sendTest_PipeOut_deq,
       RDY_sendTest_PipeOut_first,
       RDY_sendTest_PipeOut_notEmpty,
       RDY_startCopy_PipeOut_deq,
       RDY_startCopy_PipeOut_first,
       RDY_startCopy_PipeOut_notEmpty,
       RDY_writePage_PipeOut_deq,
       RDY_writePage_PipeOut_first,
       RDY_writePage_PipeOut_notEmpty,
       addReadHostBuffer_PipeOut_notEmpty,
       addWriteHostBuffer_PipeOut_notEmpty,
       inputPipes_0_notFull,
       inputPipes_1_notFull,
       inputPipes_2_notFull,
       inputPipes_3_notFull,
       inputPipes_4_notFull,
       inputPipes_5_notFull,
       readPage_PipeOut_notEmpty,
       sendTest_PipeOut_notEmpty,
       startCopy_PipeOut_notEmpty,
       writePage_PipeOut_notEmpty;

  // register addReadHostBuffer_requestFifo_count
  reg [31 : 0] addReadHostBuffer_requestFifo_count;
  wire [31 : 0] addReadHostBuffer_requestFifo_count_D_IN;
  wire addReadHostBuffer_requestFifo_count_EN;

  // register addReadHostBuffer_requestFifo_fbnbuff
  reg [63 : 0] addReadHostBuffer_requestFifo_fbnbuff;
  wire [63 : 0] addReadHostBuffer_requestFifo_fbnbuff_D_IN;
  wire addReadHostBuffer_requestFifo_fbnbuff_EN;

  // register addWriteHostBuffer_requestFifo_count
  reg [31 : 0] addWriteHostBuffer_requestFifo_count;
  wire [31 : 0] addWriteHostBuffer_requestFifo_count_D_IN;
  wire addWriteHostBuffer_requestFifo_count_EN;

  // register addWriteHostBuffer_requestFifo_fbnbuff
  reg [63 : 0] addWriteHostBuffer_requestFifo_fbnbuff;
  wire [63 : 0] addWriteHostBuffer_requestFifo_fbnbuff_D_IN;
  wire addWriteHostBuffer_requestFifo_fbnbuff_EN;

  // register readPage_requestFifo_count
  reg [31 : 0] readPage_requestFifo_count;
  wire [31 : 0] readPage_requestFifo_count_D_IN;
  wire readPage_requestFifo_count_EN;

  // register readPage_requestFifo_fbnbuff
  reg [159 : 0] readPage_requestFifo_fbnbuff;
  wire [159 : 0] readPage_requestFifo_fbnbuff_D_IN;
  wire readPage_requestFifo_fbnbuff_EN;

  // register sendTest_requestFifo_count
  reg [31 : 0] sendTest_requestFifo_count;
  wire [31 : 0] sendTest_requestFifo_count_D_IN;
  wire sendTest_requestFifo_count_EN;

  // register sendTest_requestFifo_fbnbuff
  reg [31 : 0] sendTest_requestFifo_fbnbuff;
  wire [31 : 0] sendTest_requestFifo_fbnbuff_D_IN;
  wire sendTest_requestFifo_fbnbuff_EN;

  // register startCopy_requestFifo_count
  reg [31 : 0] startCopy_requestFifo_count;
  wire [31 : 0] startCopy_requestFifo_count_D_IN;
  wire startCopy_requestFifo_count_EN;

  // register startCopy_requestFifo_fbnbuff
  reg [159 : 0] startCopy_requestFifo_fbnbuff;
  wire [159 : 0] startCopy_requestFifo_fbnbuff_D_IN;
  wire startCopy_requestFifo_fbnbuff_EN;

  // register writePage_requestFifo_count
  reg [31 : 0] writePage_requestFifo_count;
  wire [31 : 0] writePage_requestFifo_count_D_IN;
  wire writePage_requestFifo_count_EN;

  // register writePage_requestFifo_fbnbuff
  reg [159 : 0] writePage_requestFifo_fbnbuff;
  wire [159 : 0] writePage_requestFifo_fbnbuff_D_IN;
  wire writePage_requestFifo_fbnbuff_EN;

  // ports of submodule addReadHostBuffer_requestFifo_fifo
  wire [63 : 0] addReadHostBuffer_requestFifo_fifo_D_IN,
		addReadHostBuffer_requestFifo_fifo_D_OUT;
  wire addReadHostBuffer_requestFifo_fifo_CLR,
       addReadHostBuffer_requestFifo_fifo_DEQ,
       addReadHostBuffer_requestFifo_fifo_EMPTY_N,
       addReadHostBuffer_requestFifo_fifo_ENQ,
       addReadHostBuffer_requestFifo_fifo_FULL_N;

  // ports of submodule addWriteHostBuffer_requestFifo_fifo
  wire [63 : 0] addWriteHostBuffer_requestFifo_fifo_D_IN,
		addWriteHostBuffer_requestFifo_fifo_D_OUT;
  wire addWriteHostBuffer_requestFifo_fifo_CLR,
       addWriteHostBuffer_requestFifo_fifo_DEQ,
       addWriteHostBuffer_requestFifo_fifo_EMPTY_N,
       addWriteHostBuffer_requestFifo_fifo_ENQ,
       addWriteHostBuffer_requestFifo_fifo_FULL_N;

  // ports of submodule readPage_requestFifo_fifo
  wire [159 : 0] readPage_requestFifo_fifo_D_IN,
		 readPage_requestFifo_fifo_D_OUT;
  wire readPage_requestFifo_fifo_CLR,
       readPage_requestFifo_fifo_DEQ,
       readPage_requestFifo_fifo_EMPTY_N,
       readPage_requestFifo_fifo_ENQ,
       readPage_requestFifo_fifo_FULL_N;

  // ports of submodule sendTest_requestFifo_fifo
  wire [31 : 0] sendTest_requestFifo_fifo_D_IN,
		sendTest_requestFifo_fifo_D_OUT;
  wire sendTest_requestFifo_fifo_CLR,
       sendTest_requestFifo_fifo_DEQ,
       sendTest_requestFifo_fifo_EMPTY_N,
       sendTest_requestFifo_fifo_ENQ,
       sendTest_requestFifo_fifo_FULL_N;

  // ports of submodule startCopy_requestFifo_fifo
  wire [159 : 0] startCopy_requestFifo_fifo_D_IN,
		 startCopy_requestFifo_fifo_D_OUT;
  wire startCopy_requestFifo_fifo_CLR,
       startCopy_requestFifo_fifo_DEQ,
       startCopy_requestFifo_fifo_EMPTY_N,
       startCopy_requestFifo_fifo_ENQ,
       startCopy_requestFifo_fifo_FULL_N;

  // ports of submodule writePage_requestFifo_fifo
  wire [159 : 0] writePage_requestFifo_fifo_D_IN,
		 writePage_requestFifo_fifo_D_OUT;
  wire writePage_requestFifo_fifo_CLR,
       writePage_requestFifo_fifo_DEQ,
       writePage_requestFifo_fifo_EMPTY_N,
       writePage_requestFifo_fifo_ENQ,
       writePage_requestFifo_fifo_FULL_N;

  // remaining internal signals
  wire [31 : 0] x__h1515, x__h1639, x__h1763, x__h1885, x__h2008, x__h2132;

  // action method inputPipes_0_enq
  assign RDY_inputPipes_0_enq =
	     startCopy_requestFifo_count < 32'd4 ||
	     startCopy_requestFifo_fifo_FULL_N ;

  // value method inputPipes_0_notFull
  assign inputPipes_0_notFull = startCopy_requestFifo_fifo_FULL_N ;
  assign RDY_inputPipes_0_notFull = 1'd1 ;

  // action method inputPipes_1_enq
  assign RDY_inputPipes_1_enq =
	     readPage_requestFifo_count < 32'd4 ||
	     readPage_requestFifo_fifo_FULL_N ;

  // value method inputPipes_1_notFull
  assign inputPipes_1_notFull = readPage_requestFifo_fifo_FULL_N ;
  assign RDY_inputPipes_1_notFull = 1'd1 ;

  // action method inputPipes_2_enq
  assign RDY_inputPipes_2_enq =
	     writePage_requestFifo_count < 32'd4 ||
	     writePage_requestFifo_fifo_FULL_N ;

  // value method inputPipes_2_notFull
  assign inputPipes_2_notFull = writePage_requestFifo_fifo_FULL_N ;
  assign RDY_inputPipes_2_notFull = 1'd1 ;

  // action method inputPipes_3_enq
  assign RDY_inputPipes_3_enq = sendTest_requestFifo_fifo_FULL_N ;

  // value method inputPipes_3_notFull
  assign inputPipes_3_notFull = sendTest_requestFifo_fifo_FULL_N ;
  assign RDY_inputPipes_3_notFull = 1'd1 ;

  // action method inputPipes_4_enq
  assign RDY_inputPipes_4_enq =
	     addWriteHostBuffer_requestFifo_count == 32'd0 ||
	     addWriteHostBuffer_requestFifo_fifo_FULL_N ;

  // value method inputPipes_4_notFull
  assign inputPipes_4_notFull = addWriteHostBuffer_requestFifo_fifo_FULL_N ;
  assign RDY_inputPipes_4_notFull = 1'd1 ;

  // action method inputPipes_5_enq
  assign RDY_inputPipes_5_enq =
	     addReadHostBuffer_requestFifo_count == 32'd0 ||
	     addReadHostBuffer_requestFifo_fifo_FULL_N ;

  // value method inputPipes_5_notFull
  assign inputPipes_5_notFull = addReadHostBuffer_requestFifo_fifo_FULL_N ;
  assign RDY_inputPipes_5_notFull = 1'd1 ;

  // value method requestSizeBits
  assign requestSizeBits =
	     192'h000000400000004000000020000000A0000000A0000000A0 ;
  assign RDY_requestSizeBits = 1'd1 ;

  // value method startCopy_PipeOut_first
  assign startCopy_PipeOut_first = startCopy_requestFifo_fifo_D_OUT ;
  assign RDY_startCopy_PipeOut_first = startCopy_requestFifo_fifo_EMPTY_N ;

  // action method startCopy_PipeOut_deq
  assign RDY_startCopy_PipeOut_deq = startCopy_requestFifo_fifo_EMPTY_N ;

  // value method startCopy_PipeOut_notEmpty
  assign startCopy_PipeOut_notEmpty = startCopy_requestFifo_fifo_EMPTY_N ;
  assign RDY_startCopy_PipeOut_notEmpty = 1'd1 ;

  // value method readPage_PipeOut_first
  assign readPage_PipeOut_first = readPage_requestFifo_fifo_D_OUT ;
  assign RDY_readPage_PipeOut_first = readPage_requestFifo_fifo_EMPTY_N ;

  // action method readPage_PipeOut_deq
  assign RDY_readPage_PipeOut_deq = readPage_requestFifo_fifo_EMPTY_N ;

  // value method readPage_PipeOut_notEmpty
  assign readPage_PipeOut_notEmpty = readPage_requestFifo_fifo_EMPTY_N ;
  assign RDY_readPage_PipeOut_notEmpty = 1'd1 ;

  // value method writePage_PipeOut_first
  assign writePage_PipeOut_first = writePage_requestFifo_fifo_D_OUT ;
  assign RDY_writePage_PipeOut_first = writePage_requestFifo_fifo_EMPTY_N ;

  // action method writePage_PipeOut_deq
  assign RDY_writePage_PipeOut_deq = writePage_requestFifo_fifo_EMPTY_N ;

  // value method writePage_PipeOut_notEmpty
  assign writePage_PipeOut_notEmpty = writePage_requestFifo_fifo_EMPTY_N ;
  assign RDY_writePage_PipeOut_notEmpty = 1'd1 ;

  // value method sendTest_PipeOut_first
  assign sendTest_PipeOut_first = sendTest_requestFifo_fifo_D_OUT ;
  assign RDY_sendTest_PipeOut_first = sendTest_requestFifo_fifo_EMPTY_N ;

  // action method sendTest_PipeOut_deq
  assign RDY_sendTest_PipeOut_deq = sendTest_requestFifo_fifo_EMPTY_N ;

  // value method sendTest_PipeOut_notEmpty
  assign sendTest_PipeOut_notEmpty = sendTest_requestFifo_fifo_EMPTY_N ;
  assign RDY_sendTest_PipeOut_notEmpty = 1'd1 ;

  // value method addWriteHostBuffer_PipeOut_first
  assign addWriteHostBuffer_PipeOut_first =
	     addWriteHostBuffer_requestFifo_fifo_D_OUT ;
  assign RDY_addWriteHostBuffer_PipeOut_first =
	     addWriteHostBuffer_requestFifo_fifo_EMPTY_N ;

  // action method addWriteHostBuffer_PipeOut_deq
  assign RDY_addWriteHostBuffer_PipeOut_deq =
	     addWriteHostBuffer_requestFifo_fifo_EMPTY_N ;

  // value method addWriteHostBuffer_PipeOut_notEmpty
  assign addWriteHostBuffer_PipeOut_notEmpty =
	     addWriteHostBuffer_requestFifo_fifo_EMPTY_N ;
  assign RDY_addWriteHostBuffer_PipeOut_notEmpty = 1'd1 ;

  // value method addReadHostBuffer_PipeOut_first
  assign addReadHostBuffer_PipeOut_first =
	     addReadHostBuffer_requestFifo_fifo_D_OUT ;
  assign RDY_addReadHostBuffer_PipeOut_first =
	     addReadHostBuffer_requestFifo_fifo_EMPTY_N ;

  // action method addReadHostBuffer_PipeOut_deq
  assign RDY_addReadHostBuffer_PipeOut_deq =
	     addReadHostBuffer_requestFifo_fifo_EMPTY_N ;

  // value method addReadHostBuffer_PipeOut_notEmpty
  assign addReadHostBuffer_PipeOut_notEmpty =
	     addReadHostBuffer_requestFifo_fifo_EMPTY_N ;
  assign RDY_addReadHostBuffer_PipeOut_notEmpty = 1'd1 ;

  // submodule addReadHostBuffer_requestFifo_fifo
  FIFO1 #(.width(32'd64),
	  .guarded(32'd1)) addReadHostBuffer_requestFifo_fifo(.RST(RST_N),
							      .CLK(CLK),
							      .D_IN(addReadHostBuffer_requestFifo_fifo_D_IN),
							      .ENQ(addReadHostBuffer_requestFifo_fifo_ENQ),
							      .DEQ(addReadHostBuffer_requestFifo_fifo_DEQ),
							      .CLR(addReadHostBuffer_requestFifo_fifo_CLR),
							      .D_OUT(addReadHostBuffer_requestFifo_fifo_D_OUT),
							      .FULL_N(addReadHostBuffer_requestFifo_fifo_FULL_N),
							      .EMPTY_N(addReadHostBuffer_requestFifo_fifo_EMPTY_N));

  // submodule addWriteHostBuffer_requestFifo_fifo
  FIFO1 #(.width(32'd64),
	  .guarded(32'd1)) addWriteHostBuffer_requestFifo_fifo(.RST(RST_N),
							       .CLK(CLK),
							       .D_IN(addWriteHostBuffer_requestFifo_fifo_D_IN),
							       .ENQ(addWriteHostBuffer_requestFifo_fifo_ENQ),
							       .DEQ(addWriteHostBuffer_requestFifo_fifo_DEQ),
							       .CLR(addWriteHostBuffer_requestFifo_fifo_CLR),
							       .D_OUT(addWriteHostBuffer_requestFifo_fifo_D_OUT),
							       .FULL_N(addWriteHostBuffer_requestFifo_fifo_FULL_N),
							       .EMPTY_N(addWriteHostBuffer_requestFifo_fifo_EMPTY_N));

  // submodule readPage_requestFifo_fifo
  FIFO1 #(.width(32'd160),
	  .guarded(32'd1)) readPage_requestFifo_fifo(.RST(RST_N),
						     .CLK(CLK),
						     .D_IN(readPage_requestFifo_fifo_D_IN),
						     .ENQ(readPage_requestFifo_fifo_ENQ),
						     .DEQ(readPage_requestFifo_fifo_DEQ),
						     .CLR(readPage_requestFifo_fifo_CLR),
						     .D_OUT(readPage_requestFifo_fifo_D_OUT),
						     .FULL_N(readPage_requestFifo_fifo_FULL_N),
						     .EMPTY_N(readPage_requestFifo_fifo_EMPTY_N));

  // submodule sendTest_requestFifo_fifo
  FIFO1 #(.width(32'd32),
	  .guarded(32'd1)) sendTest_requestFifo_fifo(.RST(RST_N),
						     .CLK(CLK),
						     .D_IN(sendTest_requestFifo_fifo_D_IN),
						     .ENQ(sendTest_requestFifo_fifo_ENQ),
						     .DEQ(sendTest_requestFifo_fifo_DEQ),
						     .CLR(sendTest_requestFifo_fifo_CLR),
						     .D_OUT(sendTest_requestFifo_fifo_D_OUT),
						     .FULL_N(sendTest_requestFifo_fifo_FULL_N),
						     .EMPTY_N(sendTest_requestFifo_fifo_EMPTY_N));

  // submodule startCopy_requestFifo_fifo
  FIFO1 #(.width(32'd160),
	  .guarded(32'd1)) startCopy_requestFifo_fifo(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(startCopy_requestFifo_fifo_D_IN),
						      .ENQ(startCopy_requestFifo_fifo_ENQ),
						      .DEQ(startCopy_requestFifo_fifo_DEQ),
						      .CLR(startCopy_requestFifo_fifo_CLR),
						      .D_OUT(startCopy_requestFifo_fifo_D_OUT),
						      .FULL_N(startCopy_requestFifo_fifo_FULL_N),
						      .EMPTY_N(startCopy_requestFifo_fifo_EMPTY_N));

  // submodule writePage_requestFifo_fifo
  FIFO1 #(.width(32'd160),
	  .guarded(32'd1)) writePage_requestFifo_fifo(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(writePage_requestFifo_fifo_D_IN),
						      .ENQ(writePage_requestFifo_fifo_ENQ),
						      .DEQ(writePage_requestFifo_fifo_DEQ),
						      .CLR(writePage_requestFifo_fifo_CLR),
						      .D_OUT(writePage_requestFifo_fifo_D_OUT),
						      .FULL_N(writePage_requestFifo_fifo_FULL_N),
						      .EMPTY_N(writePage_requestFifo_fifo_EMPTY_N));

  // register addReadHostBuffer_requestFifo_count
  assign addReadHostBuffer_requestFifo_count_D_IN =
	     (addReadHostBuffer_requestFifo_count == 32'd1) ?
	       32'd0 :
	       x__h2132 ;
  assign addReadHostBuffer_requestFifo_count_EN = EN_inputPipes_5_enq ;

  // register addReadHostBuffer_requestFifo_fbnbuff
  assign addReadHostBuffer_requestFifo_fbnbuff_D_IN =
	     { addReadHostBuffer_requestFifo_fbnbuff[31:0],
	       inputPipes_5_enq_v } ;
  assign addReadHostBuffer_requestFifo_fbnbuff_EN = EN_inputPipes_5_enq ;

  // register addWriteHostBuffer_requestFifo_count
  assign addWriteHostBuffer_requestFifo_count_D_IN =
	     (addWriteHostBuffer_requestFifo_count == 32'd1) ?
	       32'd0 :
	       x__h2008 ;
  assign addWriteHostBuffer_requestFifo_count_EN = EN_inputPipes_4_enq ;

  // register addWriteHostBuffer_requestFifo_fbnbuff
  assign addWriteHostBuffer_requestFifo_fbnbuff_D_IN =
	     { addWriteHostBuffer_requestFifo_fbnbuff[31:0],
	       inputPipes_4_enq_v } ;
  assign addWriteHostBuffer_requestFifo_fbnbuff_EN = EN_inputPipes_4_enq ;

  // register readPage_requestFifo_count
  assign readPage_requestFifo_count_D_IN =
	     (readPage_requestFifo_count == 32'd4) ? 32'd0 : x__h1639 ;
  assign readPage_requestFifo_count_EN = EN_inputPipes_1_enq ;

  // register readPage_requestFifo_fbnbuff
  assign readPage_requestFifo_fbnbuff_D_IN =
	     { readPage_requestFifo_fbnbuff[127:0], inputPipes_1_enq_v } ;
  assign readPage_requestFifo_fbnbuff_EN = EN_inputPipes_1_enq ;

  // register sendTest_requestFifo_count
  assign sendTest_requestFifo_count_D_IN =
	     (sendTest_requestFifo_count == 32'd0) ?
	       sendTest_requestFifo_count :
	       x__h1885 ;
  assign sendTest_requestFifo_count_EN = EN_inputPipes_3_enq ;

  // register sendTest_requestFifo_fbnbuff
  assign sendTest_requestFifo_fbnbuff_D_IN = inputPipes_3_enq_v ;
  assign sendTest_requestFifo_fbnbuff_EN = EN_inputPipes_3_enq ;

  // register startCopy_requestFifo_count
  assign startCopy_requestFifo_count_D_IN =
	     (startCopy_requestFifo_count == 32'd4) ? 32'd0 : x__h1515 ;
  assign startCopy_requestFifo_count_EN = EN_inputPipes_0_enq ;

  // register startCopy_requestFifo_fbnbuff
  assign startCopy_requestFifo_fbnbuff_D_IN =
	     { startCopy_requestFifo_fbnbuff[127:0], inputPipes_0_enq_v } ;
  assign startCopy_requestFifo_fbnbuff_EN = EN_inputPipes_0_enq ;

  // register writePage_requestFifo_count
  assign writePage_requestFifo_count_D_IN =
	     (writePage_requestFifo_count == 32'd4) ? 32'd0 : x__h1763 ;
  assign writePage_requestFifo_count_EN = EN_inputPipes_2_enq ;

  // register writePage_requestFifo_fbnbuff
  assign writePage_requestFifo_fbnbuff_D_IN =
	     { writePage_requestFifo_fbnbuff[127:0], inputPipes_2_enq_v } ;
  assign writePage_requestFifo_fbnbuff_EN = EN_inputPipes_2_enq ;

  // submodule addReadHostBuffer_requestFifo_fifo
  assign addReadHostBuffer_requestFifo_fifo_D_IN =
	     { addReadHostBuffer_requestFifo_fbnbuff[31:0],
	       inputPipes_5_enq_v } ;
  assign addReadHostBuffer_requestFifo_fifo_ENQ =
	     EN_inputPipes_5_enq &&
	     addReadHostBuffer_requestFifo_count == 32'd1 ;
  assign addReadHostBuffer_requestFifo_fifo_DEQ =
	     EN_addReadHostBuffer_PipeOut_deq ;
  assign addReadHostBuffer_requestFifo_fifo_CLR = 1'b0 ;

  // submodule addWriteHostBuffer_requestFifo_fifo
  assign addWriteHostBuffer_requestFifo_fifo_D_IN =
	     { addWriteHostBuffer_requestFifo_fbnbuff[31:0],
	       inputPipes_4_enq_v } ;
  assign addWriteHostBuffer_requestFifo_fifo_ENQ =
	     EN_inputPipes_4_enq &&
	     addWriteHostBuffer_requestFifo_count == 32'd1 ;
  assign addWriteHostBuffer_requestFifo_fifo_DEQ =
	     EN_addWriteHostBuffer_PipeOut_deq ;
  assign addWriteHostBuffer_requestFifo_fifo_CLR = 1'b0 ;

  // submodule readPage_requestFifo_fifo
  assign readPage_requestFifo_fifo_D_IN =
	     { readPage_requestFifo_fbnbuff[127:0], inputPipes_1_enq_v } ;
  assign readPage_requestFifo_fifo_ENQ =
	     EN_inputPipes_1_enq && readPage_requestFifo_count == 32'd4 ;
  assign readPage_requestFifo_fifo_DEQ = EN_readPage_PipeOut_deq ;
  assign readPage_requestFifo_fifo_CLR = 1'b0 ;

  // submodule sendTest_requestFifo_fifo
  assign sendTest_requestFifo_fifo_D_IN = inputPipes_3_enq_v ;
  assign sendTest_requestFifo_fifo_ENQ =
	     EN_inputPipes_3_enq && sendTest_requestFifo_count == 32'd0 ;
  assign sendTest_requestFifo_fifo_DEQ = EN_sendTest_PipeOut_deq ;
  assign sendTest_requestFifo_fifo_CLR = 1'b0 ;

  // submodule startCopy_requestFifo_fifo
  assign startCopy_requestFifo_fifo_D_IN =
	     { startCopy_requestFifo_fbnbuff[127:0], inputPipes_0_enq_v } ;
  assign startCopy_requestFifo_fifo_ENQ =
	     EN_inputPipes_0_enq && startCopy_requestFifo_count == 32'd4 ;
  assign startCopy_requestFifo_fifo_DEQ = EN_startCopy_PipeOut_deq ;
  assign startCopy_requestFifo_fifo_CLR = 1'b0 ;

  // submodule writePage_requestFifo_fifo
  assign writePage_requestFifo_fifo_D_IN =
	     { writePage_requestFifo_fbnbuff[127:0], inputPipes_2_enq_v } ;
  assign writePage_requestFifo_fifo_ENQ =
	     EN_inputPipes_2_enq && writePage_requestFifo_count == 32'd4 ;
  assign writePage_requestFifo_fifo_DEQ = EN_writePage_PipeOut_deq ;
  assign writePage_requestFifo_fifo_CLR = 1'b0 ;

  // remaining internal signals
  assign x__h1515 = startCopy_requestFifo_count + 32'd1 ;
  assign x__h1639 = readPage_requestFifo_count + 32'd1 ;
  assign x__h1763 = writePage_requestFifo_count + 32'd1 ;
  assign x__h1885 = sendTest_requestFifo_count + 32'd1 ;
  assign x__h2008 = addWriteHostBuffer_requestFifo_count + 32'd1 ;
  assign x__h2132 = addReadHostBuffer_requestFifo_count + 32'd1 ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        addReadHostBuffer_requestFifo_count <= `BSV_ASSIGNMENT_DELAY 32'd0;
	addReadHostBuffer_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY 64'd0;
	addWriteHostBuffer_requestFifo_count <= `BSV_ASSIGNMENT_DELAY 32'd0;
	addWriteHostBuffer_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY 64'd0;
	readPage_requestFifo_count <= `BSV_ASSIGNMENT_DELAY 32'd0;
	readPage_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY 160'd0;
	sendTest_requestFifo_count <= `BSV_ASSIGNMENT_DELAY 32'd0;
	sendTest_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY 32'd0;
	startCopy_requestFifo_count <= `BSV_ASSIGNMENT_DELAY 32'd0;
	startCopy_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY 160'd0;
	writePage_requestFifo_count <= `BSV_ASSIGNMENT_DELAY 32'd0;
	writePage_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY 160'd0;
      end
    else
      begin
        if (addReadHostBuffer_requestFifo_count_EN)
	  addReadHostBuffer_requestFifo_count <= `BSV_ASSIGNMENT_DELAY
	      addReadHostBuffer_requestFifo_count_D_IN;
	if (addReadHostBuffer_requestFifo_fbnbuff_EN)
	  addReadHostBuffer_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY
	      addReadHostBuffer_requestFifo_fbnbuff_D_IN;
	if (addWriteHostBuffer_requestFifo_count_EN)
	  addWriteHostBuffer_requestFifo_count <= `BSV_ASSIGNMENT_DELAY
	      addWriteHostBuffer_requestFifo_count_D_IN;
	if (addWriteHostBuffer_requestFifo_fbnbuff_EN)
	  addWriteHostBuffer_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY
	      addWriteHostBuffer_requestFifo_fbnbuff_D_IN;
	if (readPage_requestFifo_count_EN)
	  readPage_requestFifo_count <= `BSV_ASSIGNMENT_DELAY
	      readPage_requestFifo_count_D_IN;
	if (readPage_requestFifo_fbnbuff_EN)
	  readPage_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY
	      readPage_requestFifo_fbnbuff_D_IN;
	if (sendTest_requestFifo_count_EN)
	  sendTest_requestFifo_count <= `BSV_ASSIGNMENT_DELAY
	      sendTest_requestFifo_count_D_IN;
	if (sendTest_requestFifo_fbnbuff_EN)
	  sendTest_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY
	      sendTest_requestFifo_fbnbuff_D_IN;
	if (startCopy_requestFifo_count_EN)
	  startCopy_requestFifo_count <= `BSV_ASSIGNMENT_DELAY
	      startCopy_requestFifo_count_D_IN;
	if (startCopy_requestFifo_fbnbuff_EN)
	  startCopy_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY
	      startCopy_requestFifo_fbnbuff_D_IN;
	if (writePage_requestFifo_count_EN)
	  writePage_requestFifo_count <= `BSV_ASSIGNMENT_DELAY
	      writePage_requestFifo_count_D_IN;
	if (writePage_requestFifo_fbnbuff_EN)
	  writePage_requestFifo_fbnbuff <= `BSV_ASSIGNMENT_DELAY
	      writePage_requestFifo_fbnbuff_D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    addReadHostBuffer_requestFifo_count = 32'hAAAAAAAA;
    addReadHostBuffer_requestFifo_fbnbuff = 64'hAAAAAAAAAAAAAAAA;
    addWriteHostBuffer_requestFifo_count = 32'hAAAAAAAA;
    addWriteHostBuffer_requestFifo_fbnbuff = 64'hAAAAAAAAAAAAAAAA;
    readPage_requestFifo_count = 32'hAAAAAAAA;
    readPage_requestFifo_fbnbuff =
	160'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
    sendTest_requestFifo_count = 32'hAAAAAAAA;
    sendTest_requestFifo_fbnbuff = 32'hAAAAAAAA;
    startCopy_requestFifo_count = 32'hAAAAAAAA;
    startCopy_requestFifo_fbnbuff =
	160'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
    writePage_requestFifo_count = 32'hAAAAAAAA;
    writePage_requestFifo_fbnbuff =
	160'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkFlashRequestWrapperPipes
