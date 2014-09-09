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
 ////////////////////////////////////////////////////////////////////////////////
 // Design Name: aurora_X1Y24_gt_common_wrapper
 //
 // Module aurora_X1Y24_gt_common_wrapper
 `timescale 1ns / 1ps

(* DowngradeIPIdentifiedWarnings="yes" *) 
module gt_common_wrapper_119
(
    output                     gt_qpllclk_quad7_out,
    output                     gt_qpllrefclk_quad7_out,

    input           GT0_GTREFCLK0_COMMON_IN,
    //----------------------- Common Block - QPLL Ports ------------------------

    //output          GT0_QPLLLOCK_OUT,

    input           GT0_QPLLLOCKDETCLK_IN

    //output          GT0_QPLLREFCLKLOST_OUT

);
    
parameter   WRAPPER_SIM_GTRESET_SPEEDUP    = "TRUE";    // Set to "TRUE" to speed up sim reset

 //***************************** Wire Declarations *****************************
     wire                    tied_to_ground_i;
     wire    [63:0]          tied_to_ground_vec_i;
     wire                    tied_to_vcc_i;

     //-------------------------  Static signal Assigments ---------------------   
     assign tied_to_ground_i             = 1'b0;
     assign tied_to_ground_vec_i         = 64'h0000000000000000;
     assign tied_to_vcc_i             = 1'b1;




 
    //_________________________________________________________________________
    //_________________________GTXE2_COMMON____________________________________
    //_________________________________________________________________________
 
    GTXE2_COMMON #
    (
            // Simulation attributes
            .SIM_RESET_SPEEDUP                      (WRAPPER_SIM_GTRESET_SPEEDUP),
            .SIM_QPLLREFCLK_SEL                     (3'b011),
            .SIM_VERSION                            ("4.0"),
 
 
           //----------------COMMON BLOCK---------------
            .BIAS_CFG                               (64'h0000040000001000),
            .COMMON_CFG                             (32'h00000000),
            .QPLL_CFG                               (27'h06801C1), 
            .QPLL_CLKOUT_CFG                        (4'b0000),
            .QPLL_COARSE_FREQ_OVRD                  (6'b010000),
            .QPLL_COARSE_FREQ_OVRD_EN               (1'b0),
            .QPLL_CP                                (10'b0000011111),
            .QPLL_CP_MONITOR_EN                     (1'b0),
            .QPLL_DMONITOR_SEL                      (1'b0),
            .QPLL_FBDIV                             (10'b0000100000), 
            .QPLL_FBDIV_MONITOR_EN                  (1'b0),
            .QPLL_FBDIV_RATIO                       (1'b1), 
            .QPLL_INIT_CFG                          (24'h000006),
            .QPLL_LOCK_CFG                          (16'h21E8),
            .QPLL_LPF                               (4'b1111),
            .QPLL_REFCLK_DIV                        (1)
 
    )
      gtxe2_common_i 
    (
        //--------- Common Block  - Dynamic Reconfiguration Port (DRP) -----------
        .DRPADDR                                    (tied_to_ground_vec_i[7:0]),
        .DRPCLK                                     (tied_to_ground_i),
        .DRPDI                                      (tied_to_ground_vec_i[15:0]),
        .DRPDO                                      (),
        .DRPEN                                      (tied_to_ground_i),
        .DRPRDY                                     (),
        .DRPWE                                      (tied_to_ground_i),
        //-------------------- Common Block  - Ref Clock Ports ---------------------
        .GTGREFCLK                                  (tied_to_ground_i),
        //.GTNORTHREFCLK0                             (tied_to_ground_i),
        .GTNORTHREFCLK0                             (GT0_GTREFCLK0_COMMON_IN),
        .GTNORTHREFCLK1                             (tied_to_ground_i),
        //.GTREFCLK0                                  (GT0_GTREFCLK0_COMMON_IN),
        .GTREFCLK0                                  (tied_to_ground_i),
        .GTREFCLK1                                  (tied_to_ground_i),
        .GTSOUTHREFCLK0                             (tied_to_ground_i),
        .GTSOUTHREFCLK1                             (tied_to_ground_i),
        //----------------------- Common Block - QPLL Ports ------------------------
        .QPLLFBCLKLOST                              (),
        //.QPLLLOCK                                   (GT0_QPLLLOCK_OUT),
        .QPLLLOCK                                   (),
        .QPLLLOCKDETCLK                             (GT0_QPLLLOCKDETCLK_IN),
        .QPLLLOCKEN                                 (tied_to_vcc_i),
        .QPLLOUTCLK                                 (gt_qpllclk_quad7_out),
        .QPLLOUTREFCLK                              (gt_qpllrefclk_quad7_out),
        .QPLLOUTRESET                               (tied_to_ground_i),
        .QPLLPD                                     (tied_to_vcc_i),
        //.QPLLREFCLKLOST                             (GT0_QPLLREFCLKLOST_OUT),
        .QPLLREFCLKLOST                             (),
        .QPLLREFCLKSEL                              (3'b011), // wjun
        .QPLLRESET                                  (tied_to_ground_i),
        .QPLLRSVD1                                  (16'b0000000000000000),
        .QPLLRSVD2                                  (5'b11111),
        .RCALENB                                    (tied_to_vcc_i),
        .REFCLKOUTMONITOR                           (),
        //--------------------------- Common Block Ports ---------------------------
        .BGBYPASSB                                  (tied_to_vcc_i),
        .BGMONITORENB                               (tied_to_vcc_i),
        .BGPDB                                      (tied_to_vcc_i),
        .BGRCALOVRD                                 (5'b11111),
        .PMARSVD                                    (8'b00000000),
        .QPLLDMONITOR                               ()
 
    );
 
endmodule
 
