`timescale 1ns / 1ps

// 7���������ʾ
module display7(
    input               clk,
    input       [3:0]   num1,       // �Ҳ�4λ������ʾ
    input       [3:0]   num2,       // ������Ϊnum1 ~ num4
    input       [3:0]   num3,       // ��0~9������
    input       [3:0]   num4,
    output      [7:0]   enable,     // �˸����ֵ�ʹ��
    output reg  [6:0]   segment
    );
    
    // �Ĵ�������
    reg [16:0]  cnt = 0;        // ������ ���ڷ�Ƶ
    reg [3:0]   reg_ena;        // ���Ƶ�ǰ�����������
    reg [3:0]   num_current;    // ��ǰ��ʾ������
    
    // �����λ���ֲ���    
    assign enable = { 4'b1111, reg_ena };
    
    always @(posedge clk)
    begin
        cnt = cnt + 1;      // ����
        // ��Ƶ 100MHz�޷�������ʾ
        case(cnt[16:15])
            2'b00:
            begin
                reg_ena     <= 4'b0111;
                num_current <= num1;
            end
            2'b01:
            begin
                reg_ena     <= 4'b1011;
                num_current <= num2;
            end
            2'b10:
            begin
                reg_ena     <= 4'b1101;
                num_current <= num3;
            end
            2'b11:
            begin
                reg_ena     <= 4'b1110;
                num_current <= num4;
            end
        endcase
    end
    
    always @(*)
    begin
        case(num_current)
            4'd0    : segment <= 7'b1000000;
            4'd1    : segment <= 7'b1111001;
            4'd2    : segment <= 7'b0100100;
            4'd3    : segment <= 7'b0110000;
            4'd4    : segment <= 7'b0011001;
            4'd5    : segment <= 7'b0010010;
            4'd6    : segment <= 7'b0000010;
            4'd7    : segment <= 7'b1111000;
            4'd8    : segment <= 7'b0000000;
            4'd9    : segment <= 7'b0010000;
            default : segment <= 7'b1111111;
        endcase
    end
    
endmodule
