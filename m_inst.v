`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 14:29:45
// Design Name: 
// Module Name: m_inst
// Project Name: 
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


module m_inst(
input clk,
input[13:0]addr,
output[31:0]dout
    );
    prgrom urom(.clka(clk), .addra(addr), .douta(dout));
endmodule
