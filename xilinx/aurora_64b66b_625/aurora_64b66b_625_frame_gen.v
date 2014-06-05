 ///////////////////////////////////////////////////////////////////////////////
 //
 // Project:  Aurora 64B/66B 
 // Company:  Xilinx
 //
 //
 //
 // (c) Copyright 2008 - 2009 Xilinx, Inc. All rights reserved.
 //
 // This file contains confidential and proprietary information
 // of Xilinx, Inc. and is protected under U.S. and
 // international copyright and other intellectual property
 // laws.
 //
 // DISCLAIMER
 // This disclaimer is not a license and does not grant any
 // rights to the materials distributed herewith. Except as
 // otherwise provided in a valid license issued to you by
 // Xilinx, and to the maximum extent permitted by applicable
 // law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
 // WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
 // AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
 // BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
 // INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
 // (2) Xilinx shall not be liable (whether in contract or tort,
 // including negligence, or under any other theory of
 // liability) for any loss or damage of any kind or nature
 // related to, arising under or in connection with these
 // materials, including for any direct, or any indirect,
 // special, incidental, or consequential loss or damage
 // (including loss of data, profits, goodwill, or any type of
 // loss or damage suffered as a result of any action brought
 // by a third party) even if such damage or loss was
 // reasonably foreseeable or Xilinx had been advised of the
 // possibility of the same.
 //
 // CRITICAL APPLICATIONS
 // Xilinx products are not designed or intended to be fail-
 // safe, or for use in any application requiring fail-safe
 // performance, such as life-support or safety devices or
 // systems, Class III medical devices, nuclear facilities,
 // applications related to the deployment of airbags, or any
 // other applications that could lead to death, personal
 // injury, or severe property or environmental damage
 // (individually and collectively, "Critical
 // Applications"). Customer assumes the sole risk and
 // liability of any use of Xilinx products in Critical
 // Applications, subject only to applicable laws and
 // regulations governing limitations on product liability.
 //
 // THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
 // PART OF THIS FILE AT ALL TIMES.
 
 //
 //
 ///////////////////////////////////////////////////////////////////////////////
 //  FRAME GEN
 //
 //
 //  Description: This module is a pattern generator to test the Aurora
 //               designs in hardware. It generates data and passes it 
 //               through the Aurora channel. 
 ///////////////////////////////////////////////////////////////////////////////
 
 `timescale 1 ns / 10 ps
 `define DLY #1

(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_64b66b_625_FRAME_GEN
 (
     // User Interface
     TX_D,  
     TX_SRC_RDY_N,
     TX_DST_RDY_N,
 
     // System Interface
     CHANNEL_UP,
     USER_CLK,       
     RESET
 ); 
 
 //*****************************Parameter Declarations****************************
     parameter            AURORA_LANES    = 1;
     parameter            LANE_DATA_WIDTH = (AURORA_LANES*64);
     parameter            REM_BUS         = 3;
     parameter            REM_BITS_MAX    = (LANE_DATA_WIDTH/8);
     parameter            DATA_WIDTH      = 8;
 
 //***********************************Port Declarations*******************************
 
    //PDU Interface
     output    [0:LANE_DATA_WIDTH-1]  TX_D;
     output                           TX_SRC_RDY_N;
     input                            TX_DST_RDY_N;
     
     // System Interface
       input                            CHANNEL_UP; 
       input                            USER_CLK; 
       input                            RESET;  
 
 //***************************External Register Declarations***************************
 
       wire                             TX_SRC_RDY_N; 
 
 //***************************Internal Register Declarations*************************** 
 
       reg                   [0:15]     pdu_lfsr_r; 
       reg                   [0:15]     pdu_lfsr_r2; 
       reg                   [0:7]      ifg_size_r; 
     wire                             reset_i;
 //*********************************Main Body of Code**********************************

    assign reset_i = RESET || (!CHANNEL_UP); 
     //Generate random data using XNOR feedback LFSR
     always @(posedge USER_CLK)
       if(reset_i)
        begin
         pdu_lfsr_r <=  `DLY    16'hABCD;  //random seed value
        end
       else if(!TX_DST_RDY_N)
        begin
        pdu_lfsr_r  <=  `DLY    {!{pdu_lfsr_r[3]^pdu_lfsr_r[12]^pdu_lfsr_r[14]^pdu_lfsr_r[15]}, 
                                 pdu_lfsr_r[0:14]};
        end
     
     //Connect TX_D to the pdu_lfsr_r register
     assign  TX_D    = {AURORA_LANES*4{pdu_lfsr_r}};
 
     assign  TX_SRC_RDY_N    = 1'b0;
 
 endmodule 
