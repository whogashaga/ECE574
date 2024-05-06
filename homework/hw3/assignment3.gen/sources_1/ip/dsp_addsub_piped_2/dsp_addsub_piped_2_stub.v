// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Mon Apr 29 11:29:34 2024
// Host        : coe-loan-008 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top dsp_addsub_piped_2 -prefix
//               dsp_addsub_piped_2_ dsp_addsub_piped_2_stub.v
// Design      : dsp_addsub_piped_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dsp_macro_v1_0_4,Vivado 2023.2" *)
module dsp_addsub_piped_2(CLK, SEL, C, CONCAT, P)
/* synthesis syn_black_box black_box_pad_pin="SEL[0:0],C[47:0],CONCAT[47:0],P[47:0]" */
/* synthesis syn_force_seq_prim="CLK" */;
  input CLK /* synthesis syn_isclock = 1 */;
  input [0:0]SEL;
  input [47:0]C;
  input [47:0]CONCAT;
  output [47:0]P;
endmodule