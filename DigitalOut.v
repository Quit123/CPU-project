`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/14 20:33:26
// Design Name: 
// Module Name: DigitalOut
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


module DigitalOut(
input SwitchCtrl,
input IOWrite_singal,
input clk,
input rst,
input[15:0] io_read_dataP5R1, //��8λ�˿�
input [31:0] digital, //digitalû�а�˿ڣ�������ע����
output reg [7:0] seg,//��ѡ������Ч
output reg [7:0] seg1,
output reg [7:0] an //λѡ������Ч
);
reg[18:0] divclk_cnt = 0;//��Ƶ������
reg divclk = 0;//��Ƶ���ʱ��
reg [31:0]digital_tube;
//reg [31:0]dagital;   //digital��ʱ����ֵ
reg[3:0] disp_dat;//Ҫ��ʾ������
reg[2:0] disp_bit;//Ҫ��ʾ��λ
parameter maxcnt = 50000;// ���ڣ�50000*2/100M
always@(posedge clk)
begin
    if (SwitchCtrl) begin
        digital_tube = {16'b0, io_read_dataP5R1};
    end else if (!SwitchCtrl && IOWrite_singal) begin
        digital_tube = digital;
    end else begin
        digital_tube = 32'b0;
    end
    if(divclk_cnt==maxcnt)
    begin
        divclk=~divclk;
        divclk_cnt=0;
    end
    else
    begin
        divclk_cnt=divclk_cnt+1'b1;
    end
end
always@(posedge divclk) begin
    if(disp_bit >= 7)
        disp_bit=0;
     else
        disp_bit=disp_bit+1'b1;
     case (disp_bit)
        3'b000 :
        begin
            disp_dat=digital_tube[3:0];
            an=8'b00000001;//��ʾ��һ������ܣ��ߵ�ƽ��Ч
        end
        3'b001 :
        begin
            disp_dat=digital_tube[7:4];
            an=8'b00000010;//��ʾ�ڶ�������ܣ��͵�ƽ��Ч
        end
        3'b010 :
        begin
            disp_dat=digital_tube[11:8];
            an=8'b00000100;//��ʾ����������ܣ��͵�ƽ��Ч
        end
        3'b011 :
        begin
            disp_dat=digital_tube[15:12];
            an=8'b00001000;//��ʾ���ĸ�����ܣ��͵�ƽ��Ч
        end
        3'b100 :
        begin
            disp_dat=digital_tube[19:16];
            an=8'b00010000;//��ʾ���������ܣ��͵�ƽ��Ч
        end
        3'b101 :
        begin
            disp_dat=digital_tube[23:20];
            an=8'b00100000;//��ʾ����������ܣ��͵�ƽ��Ч
        end
        3'b110 :
        begin
            disp_dat=digital_tube[27:24];
            an=8'b01000000;//��ʾ���߸�����ܣ��͵�ƽ��Ч
        end
        3'b111 :
        begin
            disp_dat=digital_tube[31:28];
            an=8'b10000000;//��ʾ�ڰ˸�����ܣ��͵�ƽ��Ч
        end
        default:
        begin
            disp_dat=0;
            an=8'b00000000;
        end
    endcase
end
always@(disp_dat)
begin
    if(an > 8'b00001000) begin
        case (disp_dat)
        //��ʾ0-F
        4'h0 : seg = 8'hfc;
        4'h1 : seg = 8'h60;
        4'h2 : seg = 8'hda;
        4'h3 : seg = 8'hf2;
        4'h4 : seg = 8'h66;
        4'h5 : seg = 8'hb6;
        4'h6 : seg = 8'hbe;
        4'h7 : seg = 8'he0;
        4'h8 : seg = 8'hfe;
        4'h9 : seg = 8'hf6;
        4'ha : seg = 8'hee;
        4'hb : seg = 8'h3e;
        4'hc : seg = 8'h9c;
        4'hd : seg = 8'h7a;
        4'he : seg = 8'h9e;
        4'hf : seg = 8'h8e;
        endcase
    end
    else begin
        case (disp_dat)
        //��ʾ0-F
        4'h0 : seg1 = 8'hfc;
        4'h1 : seg1 = 8'h60;
        4'h2 : seg1 = 8'hda;
        4'h3 : seg1 = 8'hf2;
        4'h4 : seg1 = 8'h66;
        4'h5 : seg1 = 8'hb6;
        4'h6 : seg1 = 8'hbe;
        4'h7 : seg1 = 8'he0;
        4'h8 : seg1 = 8'hfe;
        4'h9 : seg1 = 8'hf6;
        4'ha : seg1 = 8'hee;
        4'hb : seg1 = 8'h3e;
        4'hc : seg1 = 8'h9c;
        4'hd : seg1 = 8'h7a;
        4'he : seg1 = 8'h9e;
        4'hf : seg1 = 8'h8e;
        endcase
    end
end
endmodule
