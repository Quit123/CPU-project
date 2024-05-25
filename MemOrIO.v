`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/05 11:22:54
// Design Name: 
// Module Name: MemOrIO
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


module MemOrIO(
//MemOrIO determine:
//1). The source of r_wdata
//2). The destination of r_rdata
    input button_a,//��ť
    input button_b,
    input button_model,
    input MemRead, //key-sign -> read memory, from Controller������mem
    input MemWrite, //key-sign -> write memory, from Controller��д��mem
    input IORead_singal, //key-sign -> read IO, from Controller����������ʾ���豸��(lw)
    input IOWrite_singal, //key-sign -> write IO, from Controller,�����ݴ����豸(sw)
    
    input[31:0] addr_in, // from alu_result in ALU
    output[31:0] addr_out, // address to Data-Memory
    
    input[31:0] mem_read_data, // data read from Data-Memory
    input[15:0] io_read_data, // data read from IO,16 bits//(From input device)
    output[31:0] rdata, // data from mem or io and write into register
    
    input[31:0] register_read_data, // data read from Decoder(register file)
    
    output [31:0] write_data, // data to memory or I/O��m_wdata, io_wdata��(���д�������)
    output LEDCtrl, //����LED�ź�
    output SwitchCtrl, //���ƿ���������Ϣ
    output DigitalCtrl, //���������
    output[15:0] led_data,
    output[1:0] ledaddr
    );
    //���������ź��ȴ���register��memory��I/O�豸��
    //�ٴ�register�ж��źţ�����������źſ�����memory����I/O�豸��
    wire[31:0] WD;//WB������ܺ�mem���������ݣ��Ҷ���ֱ�����룬mem��register����ֱ�����룬��led������ܲ���ʱ������������
    assign rdata = (IORead_singal && addr_in != 32'hffff_fc74 && addr_in != 32'hffff_fc78 && addr_in != 32'hffff_fc88) ? {16'h0000 ,io_read_data} : //(lw)
                    (IORead_singal && addr_in == 32'hffff_fc74) ? {31'b0,button_a} : 
                    (IORead_singal && addr_in == 32'hffff_fc78) ? {31'b0,button_b} :
                    (IORead_singal && addr_in == 32'hffff_fc88) ? {31'b0,button_model} : mem_read_data;//(lw)mem��register,������Ҫ��lb�����ͽ�
    assign WD = (MemWrite == 1'b1 || IOWrite_singal == 1'b1) ? register_read_data : 32'h0000_0000;//(sw)
    assign write_data = WD;//(sw)��mem��io������Ϣ
    assign led_data = (IOWrite_singal == 1'b1) ? WD[15:0] : 16'h0000;
    
    /*assign led_data = (IORead_singal == 1'b1) ? io_read_data ://��lw
                    (IOWrite_singal == 1'b1) ? WD[15:0] : 16'h0000;//��swʱ��ֻҪ��ַ��ȷ���ͻ���led����������*/
    assign LEDCtrl = (IOWrite_singal == 1'b1) ? 1'b1 : 1'b0;//(sw)led����
    assign SwitchCtrl = (IORead_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)������������
    assign DigitalCtrl = (IOWrite_singal == 1'b1) ? 1'b1 : 1'b0;//��sw������ܿ���
    assign addr_out = addr_in;//�����ַ���ڴ�����ַ
    assign ledaddr = (addr_in == 32'hffff_fc7c) ? 2'b10 :
                    (addr_in == 32'hffff_fc80) ? 2'b01 :
                    (addr_in == 32'hffff_fc84) ? 2'b11 :
                    2'b00;
endmodule
/*
    reg data;
assign addr_out = addr_in;//�����ַ���ڴ�����ַ
assign rdata = (MemRead == 1'b1) ? mem_read_data ://(lw)mem��register,������Ҫ��lb�����ͽ����޸�
               (IORead_singal == 1'b1) ? {16'h0000 ,io_read_data} : 32'h0000_0000;//(lw)io��Ĵ���
assign write_data = (MemWrite == 1'b1) ? register_read_data ://(sw)
                    (IOWrite_singal == 1'b1) ? {16'h0000, register_read_data[15:0]} : 32'hffffffff;//����û�б�Ҫǰ16bit��0��iooutputΪʲôһ��Ҫ��0��(sw)��mem��io������Ϣ
assign LEDCtrl = (IORead_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)led����ʾ���
assign SwitchCtrl = (IORead_singal == 1'b1) ? 1'b1 : 1'b0;//(lw)������������
assign DigitalCtrl = IORead_singal || IOWrite_singal;
endmodule

*/

