`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Oregon State Universiy 
// Engineer: Sanpreet Gill
// 
// Create Date: 04/07/2024 06:49:31 PM
// Design Name: 
// Module Name: nBitCounter_ASR
// Project Name: Homework 1
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


module nBitCounter_ASR #(parameter int SIZE = 8)(
    input CLK,  //Module Clock 
    input CE,   // Chip Enable
    input SR,   //Active High Asynchronous Reset
    input reg [SIZE-1 : 0] SRINIT,   //Initial array Value
    output reg [SIZE-1 : 0] DOUT    //DOUT array
    );
    
    always @(posedge CLK or posedge SR) begin
        if (SR) begin
            DOUT <= 0;
        end
        else if (CE) begin
            DOUT <= DOUT + 1'b1;            
        end
    end
endmodule