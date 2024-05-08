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
    input memRead, //key-sign -> read memory, from Controller������mem
    input memWrite, //key-sign -> write memory, from Controller��д��mem
    input ioRead, //key-sign -> read IO, from Controller�������豸
    input ioWrite, //key-sign -> write IO, from Controller,�����豸
    
    input[31:0] addr_in, // from alu_result in ALU
    output[31:0] addr_out, // address to Data-Memory
    
    input[31:0] mem_read_data, // data read from Data-Memory
    input[15:0] io_read_data, // data read from IO,16 bits//(From input device)
    output[31:0] rdata, // data from mem or io and write into register
    
    input[31:0] register_read_data, // data read from Decoder(register file)
    output [31:0] write_data, // data to memory or I/O��m_wdata, io_wdata��
                                 //����Ҳ�Ƿ�����ʾ�ƹ��ź�
    output LEDCtrl, // ����LED�ź�
    output SwitchCtrl // ���ƿ���������Ϣ
    );
    //���������ź��ȴ���register��memory��I/O�豸��
    //�ٴ�register�ж��źţ�����������źſ�����memory����I/O�豸��
    reg data;
    assign addr_out = addr_in;//�����ַ���ڴ�����ַ
    assign rdata = (memRead == 1'b1) ? mem_read_data : {16'h0000 ,io_read_data};//mem��io��Ϣд��Ĵ���
    assign write_data = (memWrite == 1'b1 || ioWrite == 1'b1) ? (memWrite == 1'b1 ? register_read_data : {16'h0000, register_read_data[15:0]}) : 32'hffffffff;//��mem��io������Ϣ
    assign LEDCtrl = (ioWrite == 1'b1) ? 1'b1 : 1'b0;//led����ʾ���
    assign SwitchCtrl = (ioRead == 1'b1) ? 1'b1 : 1'b0;//������������
endmodule

    /*always @* begin
    //��ͨ��input device�������
    if((memWrite==1'b1)||(ioWrite==1'b1))
        if(memRead == 1'b1)begin//��mem�������豸���
            write_data <= m_rdata;
        end
        if(ioRead == 1'b1)begin
            write_data <= r_rdata;//��register����д��mem
        end
    else
        write_data = 32'hZZZZZZZZ;
        if(memRead == 1'b1)begin
            data <= m_rdata;//��mem����д��register
        end
        if(ioRead == 1'b1)begin
            data <= io_rdata;//��I/O�豸����д��register
        end
    end*/
