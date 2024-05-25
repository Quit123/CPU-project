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
input reset,
//input[2:0] test_index,没有必要，控制在io_read_dataP5R1
input[15:0] io_read_dataP5R1,//开关输入数据,暂时一个开关控制绑两个bit
//input in_button,
input button_a,
input button_b,
input button_model,
//input out_button,
//input ledwrite,//现暂定有button控制开关
output[15:0] ledF6K2,//拨动开关亮灯
output[7:0] seg,
output[7:0] seg1,
output[7:0] an

//input IORead_singal,
//input MemRead,//lw
//input MemWrite,//sw
//input[31:0]ALU_result,
//input[31:0]data_in//Data in,写入的数据
//output[31:0]data_out
//output[31:0] digital_tube,//MemOrIO中的write_data，用来显示十六进制
//output check//测试场景1的011-111结果显示,并不能这样，应该要传到led模块中再输出
    );
    wire cpu_clk;
    wire cpu_uart_clk;
    //leds
    wire[1:0] ledaddr;
    wire[15:0] led_input;
    //digital
    wire[31:0] dagital;
    //IOread
    wire[15:0] io_read_data;
    //instruction
    wire cpu_j_clk;
    wire[31:0] Instruction;
    wire[31:0] next_PC_plus_4;
    //Controller
    wire[6:0] opcode;
    wire[1:0] ALUOp;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    wire MemOrIOtoReg;
    wire IORead_singal;
    wire IOWrite_singal;
    //Decoder
    wire[31:0] data_to_reg;//mem或io设备向register中写数据（lw）
    wire[31:0] imm32;
    wire[2:0] funct3;
    wire[6:0] funct7;
    wire[31:0] read_data1;
    wire[31:0] read_data2;   
    //ALU
    wire zero;
    wire[31:0] ALU_result;
    //MemOrIO
    wire[31:0] mem_addr;//mem_address
    wire[31:0] mem_data_out;//data mem输出的数据
    wire[31:0] rdata;
    wire[31:0] write_data;
    wire LEDCtrl;//用于控制LED灯是否会亮 == 1'b1拨动开关led灯才会亮
    wire SwitchCtrl;//用于控制开关输入信息是否有效 == 1'b1才能有效拨动开关
    wire DigitalCtrl;//y用于控制数码管是否会亮
    wire[15:0] led_data;
    //DMem
    wire mem_data_in;//向data mem写入的数据

    assign dagital = write_data;
    assign led_input = led_data;//当lw和sw时，只要地址正确，就会像led中输入数据
    assign opcode = Instruction[6:0];
    assign mem_data_in = write_data;
    assign data_to_reg = (MemRead == 1'b1 || IORead_singal == 1'b1) ? rdata :
                        (opcode == 7'b0110011 || opcode == 7'b0010011) ? ALU_result ://R_I_TYPE
                        32'h0000_0000;
    
    
    cpuclk Clk(.clk_in1(clk),.clk_out1(cpu_clk),.clk_out2(cpu_uart_clk),.clk_out3(cpu_j_clk));
    
    Leds leds(.ledrst(reset),.led_clk(cpu_clk),
            .ledcs(LEDCtrl),.ledaddr(ledaddr),
            .ledwdata(led_input),.ledout(ledF6K2));//先暂定2'b00，已设wire ledaddr
                                                          //先暂定是write_data，之后会有register向外的数据
    
    DigitalOut digital_out(/*.SwitchCtrl(SwitchCtrl),*/.IOWrite_singal(IOWrite_singal),
                .clk(cpu_clk),.rst(reset),/*.io_read_data(io_read_data),*/
                .digital(dagital),.seg(seg),.seg1(seg1),.an(an));
                
    IOread io_read(.reset(reset),.ior(IORead_singal),
                .switchctrl(SwitchCtrl),.ioread_data_switch(io_read_dataP5R1),
                .ioread_data(io_read_data));
    //这里进行修改，进行选择然后放入strand_PC
    //wire strand_PC;
    //assign strand_PC = 
    //执行顺序：sel_instruction -> ana_function(controller) -> read_data(decoder) -> cal(ALU) -> convey_data_to_memOrIO(MemOrIO) -> convey_data_to_mem(dmem)
    //                                                                    <---------convey_data_to_register-------
    Ana_Instruction instruction(.clk(cpu_clk),.clk_j(cpu_j_clk),.reset(reset),.Branch(Branch),
                        .zero(zero),.opcode(opcode),.ALU_result(ALU_result),
                        .Instruction(Instruction),.next_PC_plus_4(next_PC_plus_4));
    
    Controller con(.Alu_resultHigh({ALU_result[31:10]}),.opcode(opcode),
                    .Branch(Branch),.MemRead(MemRead),
                    .MemtoReg(MemtoReg),.ALUOp(ALUOp),
                    .MemWrite(MemWrite),.ALUSrc(ALUSrc),
                    .RegWrite(RegWrite),.MemOrIOtoReg(MemOrIOtoReg),
                    .IORead_singal(IORead_singal),.IOWrite_singal(IOWrite_singal));
    
    Decoder decoder(.clk(cpu_clk),.reset(reset),.Instruction(Instruction),
                    .RegWrite(RegWrite),.data_to_reg(data_to_reg),.next_PC_plus_4(next_PC_plus_4),
                    .imm32(imm32),.funct3(funct3),.funct7(funct7),
                    .read_data1(read_data1),.read_data2(read_data2));
    
    ALU alu(.read_data1(read_data1),.read_data2(read_data2),
            .imm32(imm32),.ALUOp(ALUOp),.funct3(funct3),
            .funct7(funct7), .ALUSrc(ALUSrc),.opcode(opcode),
            .ALU_result(ALU_result),.zero(zero));
    
    MemOrIO mem_or_io(.button_a(button_a),.button_b(button_b),.button_model(button_model),.MemRead(MemRead),.MemWrite(MemWrite),
                    .IORead_singal(IORead_singal),.IOWrite_singal(IOWrite_singal),
                    .addr_in(ALU_result),.addr_out(mem_addr),
                    .mem_read_data(mem_data_out),.io_read_data(io_read_data),
                    .rdata(rdata),.register_read_data(read_data2),//sw显示读的是rs2
                    .write_data(write_data),.LEDCtrl(LEDCtrl),
                    .SwitchCtrl(SwitchCtrl),.DigitalCtrl(DigitalCtrl),.led_data(led_data),.ledaddr(ledaddr));
    
    DMem data_mem(.clk(cpu_clk),.MemRead(MemRead),.MemWrite(MemWrite),
                .addr(mem_addr),.data_in(mem_data_in),.data_out(mem_data_out));

endmodule
