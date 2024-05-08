`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/01 22:03:02
// Design Name: 
// Module Name: ALU
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


module ALU(
input clk,
input [1:0]ALUOp,
input [2:0]funct3,
input funct7,
input[31:0] read_data1,
input[31:0] read_data2,
input imm32,
input ALUSrc,
output zero,
output reg [31:0]ALU_result
    );
    //lw,sw,beq, add, sub, and, or
    //add->0010
    //sub->0110
    //and->0000
    //or->0001
    
    //ALU_control
    wire[3:0] ALUControl;
    wire[31:0] operand2;
    reg [31:0]ALU_mux;
    assign operand2 = (ALUSrc == 1'b1)? imm32 : read_data2;
    assign zero = (ALU_mux == 32'h0000_0000)? 1'b1: 1'b0;
    assign ALUControl = (ALUOp == 2'b01 || (ALUOp == 2'b10 && funct3 == 3'b000 && funct7 == 1'b1)) ? 4'b0110 ://01 -> beq 10 -> sub
                        (ALUOp == 2'b00 || (ALUOp == 2'b10 && funct3 == 3'b000 && funct7 == 1'b0)) ? 4'b0010 ://00 -> load|store 10 -> add
                        (ALUOp == 2'b10 && funct3 == 3'b111) ? 4'b0000 ://and
                        (ALUOp == 2'b10 && funct3 == 3'b110) ? 4'b0001 ://or
                        4'b0000;
     always@(read_data1, read_data2, ALUControl) begin
        case(ALUControl)
            4'b0010: ALU_mux <= read_data1 + operand2;
            4'b0110: ALU_mux <= read_data1 - operand2;
            4'b0000: ALU_mux <= read_data1 & operand2;
            4'b0001: ALU_mux <= read_data1 | operand2;
        default: ALU_mux <= 32'h00000000;
        endcase
     end
     always@(posedge clk)begin
         ALU_result = (ALUOp == 2'b01) ? imm32 : ALU_mux;
     end
endmodule
