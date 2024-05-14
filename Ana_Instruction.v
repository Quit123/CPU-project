`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 17:30:37
// Design Name: 
// Module Name: Ana_Instruction
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


module Ana_Instruction(
input clk,
input reset,
input Branch,
input zero,
input ALU_result,
output[31:0] Instruction
    );
    reg[31:0] PC;
    wire isBranch;
    assign isBranch = (Branch && zero) ? 1'b1 : 1'b0;
    always@(posedge clk)begin
        if(reset == 1'b1)begin
             PC <= 32'h0000_0000;
        end
        case(isBranch)
            1'b1:begin
                PC <= PC + ALU_result;
            end
            1'b0:begin
                PC <= PC + 32'h0000_0004;
            end
        endcase
    end
    prgrom urom(.clka(clk), .addra(PC[15:2]), .douta(Instruction));
endmodule
