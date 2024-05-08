`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 15:13:51
// Design Name: 
// Module Name: ALU_control
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


module ALu_aaa(
input [1:0]ALUOp,
input [2:0]funct3,
input funct7,
input read_data1,
input read_data2,
input imm32,
input ALUSrc,
output reg [31:0]ALU_result
    );
    //lw,sw,beq, add, sub, and, or
    //add->0010
    //sub->0110
    //and->0000
    //or->0001
    
    //ALU_control
    wire[3:0] ALUControl;
    assign ALUControl = (ALUOp == 2'b00 || ALUOp == 2'b01) ? 4'b1010 ://load|store|beq
                        (ALUOp == 2'b10 && funct3 == 3'b000 && funct7 == 1'b1) ? 4'b0110 ://add
                        (ALUOp == 2'b10 && funct3 == 3'b000 && funct7 == 1'b0) ? 4'b0010 ://sub
                        (ALUOp == 2'b10 && funct3 == 3'b111) ? 4'b0000 ://and
                        (ALUOp == 2'b10 && funct3 == 3'b110) ? 4'b0001 ://or
                        4'b0000;
     always@* begin
        case(ALUControl)
            4'b1010: ALU_result <= 32'h00000000;//load/store/beq
            4'b0101: ALU_result <= read_data1 + read_data2;
            4'b0010: ALU_result <= read_data1 - read_data2;
            4'b0000: ALU_result <= read_data1 & read_data2;
            4'b0001: ALU_result <= read_data1 | read_data2;
        default: ALU_result <= 32'h00000000;
        endcase
     end
endmodule
