`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Chen
// Engineer: Yen-Chun Chen
// 
// Create Date: 05/24/2024 02:23:31 PM
// Design Name: if_module
// Module Name: if_module.sv
// Project Name: Final Project
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`include "risc_pack.v"

module if_module (
    input clk_i,
    input resetn_i,
    input ce_i,
    input start_i,  // from TOP
    input zflg_i,   // from EX 
    input [8-1:0] rdreg_i,  // from EX 
    
    // comment -- additional
    output reg [16-1:0] instruction_o
);
    
    wire [12-1:0] pmem_addr;
    wire [16-1:0] pmem_dout;
    
    wire [4-1:0] opcode;
    assign opcode = pmem_dout[15:12];
    
    // #Adr: input for jsel mux
    wire [12-1:0] jmp_addr;
    
    // JMPD 12-bit
    wire [12-1:0] jmpd_addr;
    assign jmpd_addr = pmem_dout[12-1:0];
    
    reg [12-1:0] prog_cnt;
    // program counter + 1 to next address
    wire [12-1:0] prog_cnt_plus_one;
    assign prog_cnt_plus_one = prog_cnt + 1;
    
    // extend Rd to 12-bit
    wire [12-1:0] Rd_12_bit;
    assign Rd_12_bit = {rdreg_i, 4'b0000};
    
    wire [12-1:0] after_zflg;
    assign after_zflg = (zflg_i) ? {rdreg_i, 4'b0000} : prog_cnt_plus_one;
    
    reg push;
    reg pop;
    
    // PC stack with depth of 4
    wire [12-1:0] stack_top;
    pc_stack pcstack (
        .clk_i(clk_i),
        .resetn_i(resetn_i),
        .push_i(push),
        .pop_i(pop),
        .pc_in(prog_cnt_plus_one),
        .pc_out(stack_top)
    );
    
    // jump sel mux
    wire [1:0] jmp_sel;
    assign jmp_sel = opcode[1:0];
    wire [12-1:0]after_jsel;
    assign after_jsel = (jmp_sel == 2'b00) ? after_zflg :
                        (jmp_sel == 2'b01) ? jmp_addr :
                        (jmp_sel == 2'b10) ? Rd_12_bit :
                        (jmp_sel == 2'b11) ? stack_top :
                        '0;
    
    // jump enable mux
    wire jmp_en;
    assign jmp_en = (opcode[3:2] == 2'b10);
    wire [12-1:0] after_jmp_en;
    assign after_jmp_en = (jmp_en) ? after_jsel : prog_cnt_plus_one;
    
    // avoid infinite loop
    assign pmem_addr = (start_i) ? 12'b000000000010 : after_jmp_en;
    
    blk_mem_program prog_mem (
      .clka(clk_i),      // input wire clka
      .ena(ce_i),        // input wire ena
      .addra(pmem_addr), // input wire [11 : 0] addra
      .douta(pmem_dout)  // output wire [15 : 0] douta
    );
    
//     multiplexing for pmem_addr
    always @(*)
    begin
        if (opcode == 4'b1001)                          // jmpd
//            jmp_addr = jmpd_addr;
            prog_cnt = jmp_addr;
        else if (opcode == 4'b1000 && zflg_i)   // jmpc
            prog_cnt = jmp_addr;                   
        else if (opcode == 4'b1010)                     // jmps
            push <= 1;
        else if (opcode == 4'b1011)                     // RETS
        begin
            pop <= 1;
            prog_cnt = stack_top; 
        end
        else 
            prog_cnt = prog_cnt_plus_one;
    end
    
    // if we are in reset --> do nothing
    // if not in reset --> count prog_cnt up OR ... jump/irq/... ?
    always @(posedge clk_i or negedge resetn_i)
    begin
        if (~resetn_i)
        begin
            prog_cnt <= 0;
        end
        else
        begin
            if (ce_i)
                prog_cnt <= prog_cnt_plus_one;
        end
        
    end 
    
    // Output the instruction
    always @(posedge clk_i) begin
        instruction_o <= pmem_dout;
    end
    
    //assign instruction_o = pmem_dout; 
    
endmodule
