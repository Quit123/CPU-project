`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 15:20:24
// Design Name: 
// Module Name: CPU
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


module CPU(
input clk,
input rst,
input[2:0] test_index
//input[23:0] switch2N4,
//output wire [23:0]led2N4
    );
    wire [31:0]Instruction; 
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire[1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire [31:0]imm32;
    Controller con(.opcode(Instruction[6:0]),.Branch(Branch),.MemRead(MemRead),.MemtoReg(MemtoReg),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite));
    Decoder decoder(.Instruction(Instruction),.RegWrite(RegWrite),.imm32(imm32));
endmodule
