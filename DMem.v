`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 14:33:34
// Design Name: 
// Module Name: DMem
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


module DMem(
input clk,
input MemRead,//lw
input MemWrite,//sw
input[31:0]addr,
input[31:0]data_in,//Data in,写入的数据
output[31:0]data_out);//Data out,读出的数据
wire clock;
assign clock = !clk; 
RAM udram(.clka(clock),.wea(MemWrite),.addra(addr[13:0]),.dina(data_in),.douta(data_out));
endmodule
