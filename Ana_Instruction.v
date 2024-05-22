module Ana_Instruction(
input clk,
input reset,
input Branch,
input zero,
input[31:0] ALU_result,
output[31:0] Instruction
    );
    reg [31:0] PC; // 程序计数器
    wire [31:0] nextPC;
    wire isBranch;

    // 分支条件判断
    assign isBranch = (Branch && zero) ? 1'b1 : 1'b0;

    // 下一个PC值的组合逻辑
    assign nextPC = (isBranch) ? {PC[31:2] + ALU_result[29:0], PC[1:0]}: 
                              (PC + 32'h0000_0004);
    always@(posedge clk, negedge reset)begin
        if(reset == 1'b0)begin
            PC <= 32'h0000_0000;
        end
        else begin
            PC <= nextPC;
        end
    end
    prgrom urom(.clka(clk), .addra(PC[15:2]), .douta(Instruction));
endmodule
