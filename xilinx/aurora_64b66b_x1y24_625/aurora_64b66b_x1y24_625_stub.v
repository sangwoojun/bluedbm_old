// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.1 (lin64) Build 881834 Fri Apr  4 14:00:25 MDT 2014
// Date        : Thu May 29 14:27:14 2014
// Host        : umma running 64-bit Ubuntu 12.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/wjun/work/gtx/wizard/project_1/project_1.srcs/sources_1/ip/aurora_64b66b_x1y24_625/aurora_64b66b_x1y24_625_stub.v
// Design      : aurora_64b66b_x1y24_625
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "aurora_64b66b_x1y24_625,gtwizard_v3_2,{protocol_file=aurora_64b66b}" *)
module aurora_64b66b_x1y24_625(sysclk_in, soft_reset_in, dont_reset_on_data_error_in, gt0_tx_fsm_reset_done_out, gt0_rx_fsm_reset_done_out, gt0_data_valid_in, gt0_tx_mmcm_lock_in, gt0_tx_mmcm_reset_out, gt0_rx_mmcm_lock_in, gt0_rx_mmcm_reset_out, gt0_drpaddr_in, gt0_drpclk_in, gt0_drpdi_in, gt0_drpdo_out, gt0_drpen_in, gt0_drprdy_out, gt0_drpwe_in, gt0_dmonitorout_out, gt0_loopback_in, gt0_eyescanreset_in, gt0_rxuserrdy_in, gt0_eyescandataerror_out, gt0_eyescantrigger_in, gt0_rxcdrhold_in, gt0_rxcdrovrden_in, gt0_rxusrclk_in, gt0_rxusrclk2_in, gt0_rxdata_out, gt0_rxprbserr_out, gt0_rxprbssel_in, gt0_rxprbscntreset_in, gt0_gtxrxp_in, gt0_gtxrxn_in, gt0_rxbufreset_in, gt0_rxbufstatus_out, gt0_rxlpmhfovrden_in, gt0_rxdfeagcovrden_in, gt0_rxdfelpmreset_in, gt0_rxlpmlfklovrden_in, gt0_rxmonitorout_out, gt0_rxmonitorsel_in, gt0_rxoutclk_out, gt0_rxdatavalid_out, gt0_rxheader_out, gt0_rxheadervalid_out, gt0_rxgearboxslip_in, gt0_gtrxreset_in, gt0_rxpcsreset_in, gt0_rxpmareset_in, gt0_rxlpmen_in, gt0_rxpolarity_in, gt0_rxresetdone_out, gt0_txpostcursor_in, gt0_txprecursor_in, gt0_gttxreset_in, gt0_txuserrdy_in, gt0_txusrclk_in, gt0_txusrclk2_in, gt0_txprbsforceerr_in, gt0_txbufstatus_out, gt0_txdiffctrl_in, gt0_txmaincursor_in, gt0_txdata_in, gt0_gtxtxn_out, gt0_gtxtxp_out, gt0_txoutclk_out, gt0_txoutclkfabric_out, gt0_txoutclkpcs_out, gt0_txheader_in, gt0_txsequence_in, gt0_txpcsreset_in, gt0_txpmareset_in, gt0_txresetdone_out, gt0_txpolarity_in, gt0_txprbssel_in, gt0_qplllock_in, gt0_qpllrefclklost_in, gt0_qpllreset_out, gt0_qplloutclk_in, gt0_qplloutrefclk_in)
/* synthesis syn_black_box black_box_pad_pin="sysclk_in,soft_reset_in,dont_reset_on_data_error_in,gt0_tx_fsm_reset_done_out,gt0_rx_fsm_reset_done_out,gt0_data_valid_in,gt0_tx_mmcm_lock_in,gt0_tx_mmcm_reset_out,gt0_rx_mmcm_lock_in,gt0_rx_mmcm_reset_out,gt0_drpaddr_in[8:0],gt0_drpclk_in,gt0_drpdi_in[15:0],gt0_drpdo_out[15:0],gt0_drpen_in,gt0_drprdy_out,gt0_drpwe_in,gt0_dmonitorout_out[7:0],gt0_loopback_in[2:0],gt0_eyescanreset_in,gt0_rxuserrdy_in,gt0_eyescandataerror_out,gt0_eyescantrigger_in,gt0_rxcdrhold_in,gt0_rxcdrovrden_in,gt0_rxusrclk_in,gt0_rxusrclk2_in,gt0_rxdata_out[63:0],gt0_rxprbserr_out,gt0_rxprbssel_in[2:0],gt0_rxprbscntreset_in,gt0_gtxrxp_in,gt0_gtxrxn_in,gt0_rxbufreset_in,gt0_rxbufstatus_out[2:0],gt0_rxlpmhfovrden_in,gt0_rxdfeagcovrden_in,gt0_rxdfelpmreset_in,gt0_rxlpmlfklovrden_in,gt0_rxmonitorout_out[6:0],gt0_rxmonitorsel_in[1:0],gt0_rxoutclk_out,gt0_rxdatavalid_out,gt0_rxheader_out[1:0],gt0_rxheadervalid_out,gt0_rxgearboxslip_in,gt0_gtrxreset_in,gt0_rxpcsreset_in,gt0_rxpmareset_in,gt0_rxlpmen_in,gt0_rxpolarity_in,gt0_rxresetdone_out,gt0_txpostcursor_in[4:0],gt0_txprecursor_in[4:0],gt0_gttxreset_in,gt0_txuserrdy_in,gt0_txusrclk_in,gt0_txusrclk2_in,gt0_txprbsforceerr_in,gt0_txbufstatus_out[1:0],gt0_txdiffctrl_in[3:0],gt0_txmaincursor_in[6:0],gt0_txdata_in[63:0],gt0_gtxtxn_out,gt0_gtxtxp_out,gt0_txoutclk_out,gt0_txoutclkfabric_out,gt0_txoutclkpcs_out,gt0_txheader_in[1:0],gt0_txsequence_in[6:0],gt0_txpcsreset_in,gt0_txpmareset_in,gt0_txresetdone_out,gt0_txpolarity_in,gt0_txprbssel_in[2:0],gt0_qplllock_in,gt0_qpllrefclklost_in,gt0_qpllreset_out,gt0_qplloutclk_in,gt0_qplloutrefclk_in" */;
  input sysclk_in;
  input soft_reset_in;
  input dont_reset_on_data_error_in;
  output gt0_tx_fsm_reset_done_out;
  output gt0_rx_fsm_reset_done_out;
  input gt0_data_valid_in;
  input gt0_tx_mmcm_lock_in;
  output gt0_tx_mmcm_reset_out;
  input gt0_rx_mmcm_lock_in;
  output gt0_rx_mmcm_reset_out;
  input [8:0]gt0_drpaddr_in;
  input gt0_drpclk_in;
  input [15:0]gt0_drpdi_in;
  output [15:0]gt0_drpdo_out;
  input gt0_drpen_in;
  output gt0_drprdy_out;
  input gt0_drpwe_in;
  output [7:0]gt0_dmonitorout_out;
  input [2:0]gt0_loopback_in;
  input gt0_eyescanreset_in;
  input gt0_rxuserrdy_in;
  output gt0_eyescandataerror_out;
  input gt0_eyescantrigger_in;
  input gt0_rxcdrhold_in;
  input gt0_rxcdrovrden_in;
  input gt0_rxusrclk_in;
  input gt0_rxusrclk2_in;
  output [63:0]gt0_rxdata_out;
  output gt0_rxprbserr_out;
  input [2:0]gt0_rxprbssel_in;
  input gt0_rxprbscntreset_in;
  input gt0_gtxrxp_in;
  input gt0_gtxrxn_in;
  input gt0_rxbufreset_in;
  output [2:0]gt0_rxbufstatus_out;
  input gt0_rxlpmhfovrden_in;
  input gt0_rxdfeagcovrden_in;
  input gt0_rxdfelpmreset_in;
  input gt0_rxlpmlfklovrden_in;
  output [6:0]gt0_rxmonitorout_out;
  input [1:0]gt0_rxmonitorsel_in;
  output gt0_rxoutclk_out;
  output gt0_rxdatavalid_out;
  output [1:0]gt0_rxheader_out;
  output gt0_rxheadervalid_out;
  input gt0_rxgearboxslip_in;
  input gt0_gtrxreset_in;
  input gt0_rxpcsreset_in;
  input gt0_rxpmareset_in;
  input gt0_rxlpmen_in;
  input gt0_rxpolarity_in;
  output gt0_rxresetdone_out;
  input [4:0]gt0_txpostcursor_in;
  input [4:0]gt0_txprecursor_in;
  input gt0_gttxreset_in;
  input gt0_txuserrdy_in;
  input gt0_txusrclk_in;
  input gt0_txusrclk2_in;
  input gt0_txprbsforceerr_in;
  output [1:0]gt0_txbufstatus_out;
  input [3:0]gt0_txdiffctrl_in;
  input [6:0]gt0_txmaincursor_in;
  input [63:0]gt0_txdata_in;
  output gt0_gtxtxn_out;
  output gt0_gtxtxp_out;
  output gt0_txoutclk_out;
  output gt0_txoutclkfabric_out;
  output gt0_txoutclkpcs_out;
  input [1:0]gt0_txheader_in;
  input [6:0]gt0_txsequence_in;
  input gt0_txpcsreset_in;
  input gt0_txpmareset_in;
  output gt0_txresetdone_out;
  input gt0_txpolarity_in;
  input [2:0]gt0_txprbssel_in;
  input gt0_qplllock_in;
  input gt0_qpllrefclklost_in;
  output gt0_qpllreset_out;
  input gt0_qplloutclk_in;
  input gt0_qplloutrefclk_in;
endmodule
