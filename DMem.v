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
wire allow;
wire exp_data_out;
wire exp_data_in;
assign allow = MemRead || MemWrite;
RAM udram(.clka(clk),.wea(allow),.addra(addr[13:0]),.dina(exp_data_in),.douta(exp_data_out));
assign exp_data_in = MemWrite ? data_in : 32'h0000_0000;
assign data_out = MemRead ? exp_data_out : 32'h0000_0000;
endmodule
