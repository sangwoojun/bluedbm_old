// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.1 (lin64) Build 881834 Fri Apr  4 14:00:25 MDT 2014
// Date        : Tue May 20 15:57:58 2014
// Host        : umma running 64-bit Ubuntu 12.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/wjun/work/gtx/625/project_1/project_1.srcs/sources_1/ip/aurora_64b66b_625/aurora_64b66b_625_stub.v
// Design      : aurora_64b66b_625
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "aurora_64b66b_v9_2, Coregen v14.3_ip3, Number of lanes = 1, Line rate is double10.0Gbps, Reference Clock is double625.0MHz, Interface is Streaming, Flow Control is None and is operating in DUPLEX configuration" *)
module aurora_64b66b_625(s_axi_tx_tdata, s_axi_tx_tvalid, s_axi_tx_tready, do_cc, m_axi_rx_tdata, m_axi_rx_tvalid, rxp, rxn, txp, txn, refclk1_in, hard_err, soft_err, channel_up, lane_up, mmcm_not_locked, user_clk, sync_clk, reset, reset_pb, gt_rxcdrovrden_in, power_down, loopback, pma_init, gt_pll_lock, drp_clk_in, gt_qpllclk_quad7_in, gt_qpllrefclk_quad7_in, gt_to_common_qpllreset_out, gt_qpllrefclklost_in, gt_qplllock_in, drpaddr_in, drpdi_in, drpdo_out, drprdy_out, drpen_in, drpwe_in, qpll_drpaddr_in, qpll_drpdi_in, qpll_drpdo_out, qpll_drprdy_out, qpll_drpen_in, qpll_drpwe_in, init_clk, link_reset_out, sys_reset_out, tx_out_clk)
/* synthesis syn_black_box black_box_pad_pin="s_axi_tx_tdata[0:63],s_axi_tx_tvalid,s_axi_tx_tready,do_cc,m_axi_rx_tdata[0:63],m_axi_rx_tvalid,rxp[0:0],rxn[0:0],txp[0:0],txn[0:0],refclk1_in,hard_err,soft_err,channel_up,lane_up[0:0],mmcm_not_locked,user_clk,sync_clk,reset,reset_pb,gt_rxcdrovrden_in,power_down,loopback[2:0],pma_init,gt_pll_lock,drp_clk_in,gt_qpllclk_quad7_in,gt_qpllrefclk_quad7_in,gt_to_common_qpllreset_out,gt_qpllrefclklost_in,gt_qplllock_in,drpaddr_in[8:0],drpdi_in[15:0],drpdo_out[15:0],drprdy_out,drpen_in,drpwe_in,qpll_drpaddr_in[7:0],qpll_drpdi_in[15:0],qpll_drpdo_out[15:0],qpll_drprdy_out,qpll_drpen_in,qpll_drpwe_in,init_clk,link_reset_out,sys_reset_out,tx_out_clk" */;
  input [0:63]s_axi_tx_tdata;
  input s_axi_tx_tvalid;
  output s_axi_tx_tready;
  input do_cc;
  output [0:63]m_axi_rx_tdata;
  output m_axi_rx_tvalid;
  input [0:0]rxp;
  input [0:0]rxn;
  output [0:0]txp;
  output [0:0]txn;
  input refclk1_in;
  output hard_err;
  output soft_err;
  output channel_up;
  output [0:0]lane_up;
  input mmcm_not_locked;
  input user_clk;
  input sync_clk;
  input reset;
  input reset_pb;
  input gt_rxcdrovrden_in;
  input power_down;
  input [2:0]loopback;
  input pma_init;
  output gt_pll_lock;
  input drp_clk_in;
  input gt_qpllclk_quad7_in;
  input gt_qpllrefclk_quad7_in;
  output gt_to_common_qpllreset_out;
  input gt_qpllrefclklost_in;
  input gt_qplllock_in;
  input [8:0]drpaddr_in;
  input [15:0]drpdi_in;
  output [15:0]drpdo_out;
  output drprdy_out;
  input drpen_in;
  input drpwe_in;
  input [7:0]qpll_drpaddr_in;
  input [15:0]qpll_drpdi_in;
  output [15:0]qpll_drpdo_out;
  output qpll_drprdy_out;
  input qpll_drpen_in;
  input qpll_drpwe_in;
  input init_clk;
  output link_reset_out;
  output sys_reset_out;
  output tx_out_clk;
endmodule
