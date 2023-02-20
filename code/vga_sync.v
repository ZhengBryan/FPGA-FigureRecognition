`timescale 1ns / 1ps

// vga��ʾ
module vga_sync(
	input vga_clk,				// VGAʱ��
	input reset,				// ��λ�ź�

	output hsync,				// ��ͬ���ź� 
	output vsync,				// ��ͬ���ź� 

	output display_on, 			// �Ƿ���ʾ���
	output [10:0] pixel_x,	    // ��ǰ���ص������
	output [10:0] pixel_y	    // ��ǰ���ص�������
);
	
	// VGAͬ������
	parameter H_DISPLAY       = 640; 	// ����Ч��ʾ 
	parameter H_L_BORDER      =  48; 	// ����߿�
	parameter H_R_BORDER      =  16; 	// ���ұ߿�
	parameter H_SYNC          =  96; 	// ��ͬ�� 
	parameter H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_SYNC - 1;
	
	parameter V_DISPLAY       = 480;	// ����Ч��ʾ 
	parameter V_T_BORDER      =  33;	// ���ϱ߿�
	parameter V_B_BORDER      =  10;	// ���±߿�
	parameter V_SYNC          =   2;	// ��ͬ�� 
	parameter V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_SYNC - 1;   

	// VGA�г�ͬ���ź�
	assign hsync = (h_cnt < H_SYNC) ? 1'b0 : 1'b1;
	assign vsync = (v_cnt < V_SYNC) ? 1'b0 : 1'b1;
	
    // �Ƿ���ʾ���
	assign display_on = (h_cnt >= H_SYNC + H_L_BORDER) && (h_cnt < H_SYNC + H_L_BORDER + H_DISPLAY)
						&& (v_cnt >= V_SYNC + V_T_BORDER) && (v_cnt < V_SYNC + V_T_BORDER + V_DISPLAY);
	
	// �����������
	reg [10:0] h_cnt;
	reg [10:0] v_cnt;
	assign pixel_x = h_cnt - H_SYNC - H_L_BORDER;
	assign pixel_y = v_cnt - V_SYNC - V_T_BORDER;
	
    always @ (posedge vga_clk)
    begin
        if(reset)
        begin
            h_cnt <= 0;
            v_cnt <= 0;
        end
        else
        begin
            if(h_cnt == H_MAX)
            begin
                h_cnt <= 0;
                if(v_cnt == V_MAX)
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
            end
            else
                h_cnt <= h_cnt + 1;
        end
    end

endmodule
