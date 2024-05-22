`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/01 20:07:46
// Design Name: 
// Module Name: Decoder
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
    /*output[31:0] read_data1,
output[31:0] read_data2,
output Branch,
output MemRead,
output MemtoReg,
output ALUOp,
output MemWrite,
output ALUSrc,
output RegWrite*/
//no U/UJ

module Decoder(
    input clk,
    input reset,
    input[31:0] Instruction,
    input RegWrite,
    input[31:0] data_to_reg,
    input in_button,
    input decision_button,
    input out_button,
    //output shift_mount,//实现sll指令
    //output [11:0] immediate_12,//I|S|SB//实现一些特殊指令
    output[31:0] imm32,
    output[2:0] funct3,
    output[6:0] funct7,
    output[31:0] read_data1,
    output[31:0] read_data2
    //output[31:0] zero_num
    );
    integer i;
    wire [6:0] opcode;
    wire [4:0] register_address1;
    wire [4:0] register_address2;
    wire [4:0] return_address;
    reg [31:0] register[0:31];
    
    //Task 1: get information about the data from the 
    //instruction (Decoder in Data Path)
    assign opcode = Instruction[6:0];
    assign return_address = Instruction[11:7];
    assign register_address1 = Instruction[19:15];
    assign register_address2 = Instruction[24:20];
    assign funct3 = Instruction[14:12];
    assign funct7 = Instruction[31:25];
    //assign shift_mount = Instruction[24:20];//R|I
    Build_imm imm(.instruction(Instruction), .imm32(imm32));
    //Task 2: cal in register
    assign read_data1 = register[register_address1];
    assign read_data2 = register[register_address2];
    
    always@(posedge clk, negedge reset)begin
        if(in_button == 1'b1)begin
            register[5'b10110] <= 32'h0000_0001;
        end
        if(decision_button == 1'b1)begin
            register[5'b10111] <= 32'h0000_0001;
        end
        if(out_button == 1'b1)begin
            register[5'b10101] <= 32'h0000_0001;
        end
        if(reset == 1'b0) begin              // 初始化寄存器组
            for(i=0;i<32;i=i+1) register[i] <= 32'h0000_0000;
        end else if(RegWrite == 1'b1) begin
            if(funct3 == 3'b100)begin
                register[return_address] <= {24'h00_0000,data_to_reg[7:0]};//lbu 读取前8位，用0拓展
            end else if(funct3 == 3'b000) begin
                register[return_address] <= {{24{data_to_reg[7]}},data_to_reg[7:0]};//lb 读取前8位，符号拓展
            end else begin
                register[return_address] <= data_to_reg;//lw
            end
        end
    end
endmodule
