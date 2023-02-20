`timescale 1ns / 1ps

module intersection_count(
    input				clk,
    input               reset,
    input               vsync,
    input               href,
    input               clken,
    input               bin,                // ����Ķ�ֵ��bit�źţ���ɫΪ1����ɫΪ0��
    input   [10:0]      line_top,           // ʶ��������ֶ�λ����
    input   [10:0]      line_bottom,
    input   [10:0]      line_left,
    input   [10:0]      line_right,
    output reg [3:0]    v_cnt,              // ����ֱ�ָ��ߵĽ������
    output reg [3:0]    h_cnt1,             // ��ˮƽ�ָ���1�Ľ������
    output reg [3:0]    h_cnt2,             // ��ˮƽ�ָ���2�Ľ������
    output reg          h1,                 // ���һ��ˮƽ�ָ��ߵĽ����������������������໹���Ҳ�
    output reg          h2
    );

    // �������� ������
    parameter    DISPLAY_WIDTH  = 10'd640;
    parameter    DISPLAY_HEIGHT = 10'd480;
    
    // �г�����
    reg  [10:0] x_cnt;      
    reg  [10:0] y_cnt;
    
    reg         v_reg0, v_reg1, v_reg2, v_reg3;
    reg         h1_reg0, h1_reg1, h1_reg2, h1_reg3;
    reg         h2_reg0, h2_reg1, h2_reg2, h2_reg3;
    
    // �Ĵ�����ߵĽ������
    reg [3:0]   vcnt;
    reg [3:0]   hcnt1;
    reg [3:0]   hcnt2;
    reg         h1_pst;
    reg         h2_pst;
    
    // ��������Ĳο���ֵ
    wire [10:0] fig_width  = line_right - line_left;
    wire [10:0] fig_height = line_bottom - line_top;
    wire [10:0] fig_vdiv   = line_left + fig_width * 8 / 15;
    wire [10:0] fig_hdiv1  = line_top + fig_height * 3 / 10;
    wire [10:0] fig_hdiv2  = line_top + fig_height * 7 / 10;  

    // ���г�����ֱ��������ͶӰ    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            begin
                x_cnt <= 10'd0;
                y_cnt <= 10'd0;
            end
        else
            if(vsync == 0)
            begin
                x_cnt <= 10'd0;
                y_cnt <= 10'd0;
            end
            else if(clken) 
            begin
                if(x_cnt < DISPLAY_WIDTH - 1) 
                begin
                    x_cnt <= x_cnt + 1'b1;
                    y_cnt <= y_cnt;
                end
                else 
                begin
                    x_cnt <= 10'd0;
                    y_cnt <= y_cnt + 1'b1;
                end
            end
    end
    
    // �Ĵ���ֱ��������ϵ�����
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            v_reg0 <= 1'b0;
            v_reg1 <= 1'b0;
            v_reg2 <= 1'b0;
            v_reg3 <= 1'b0;
        end
        // �µ�һ֡��ʼ ��ռ���
        else if(x_cnt == 1 && y_cnt == 1)
        begin
            v_reg0 <= 1'b0;
            v_reg1 <= 1'b0;
            v_reg2 <= 1'b0;
            v_reg3 <= 1'b0;
        end
        else if(clken)
        begin
            // �µ�һ֡��ʼ
            if((x_cnt == fig_vdiv) && (y_cnt > line_top) && (y_cnt < line_bottom))
            begin
                v_reg0 <= v_reg1;
                v_reg1 <= v_reg2;
                v_reg2 <= v_reg3;
                v_reg3 <= bin;
            end
        end
    end
    
    
    // �Ĵ�ˮƽ��һ�������ϵ�����
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            h1_reg0 <= 1'b0;
            h1_reg1 <= 1'b0;
            h1_reg2 <= 1'b0;
            h1_reg3 <= 1'b0;
        end
        // �µ�һ֡��ʼ ��ռ���
        else if(x_cnt == 1 && y_cnt == 1)
        begin
            h1_reg0 <= 1'b0;
            h1_reg1 <= 1'b0;
            h1_reg2 <= 1'b0;
            h1_reg3 <= 1'b0;
        end
        else if(clken)
        begin
            // �µ�һ֡��ʼ
            if((y_cnt == fig_hdiv1) && (x_cnt > line_left) && (x_cnt < line_right))
            begin
                h1_reg0 <= h1_reg1;
                h1_reg1 <= h1_reg2;
                h1_reg2 <= h1_reg3;
                h1_reg3 <= bin;
            end
        end
    end
    
    // �Ĵ�ˮƽ�ڶ��������ϵ�����
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            h2_reg0 <= 1'b0;
            h2_reg1 <= 1'b0;
            h2_reg2 <= 1'b0;
            h2_reg3 <= 1'b0;
        end
        // �µ�һ֡��ʼ ��ռ���
        else if(x_cnt == 1 && y_cnt == 1)
        begin
            h2_reg0 <= 1'b0;
            h2_reg1 <= 1'b0;
            h2_reg2 <= 1'b0;
            h2_reg3 <= 1'b0;
        end
        else if(clken)
        begin
            // �µ�һ֡��ʼ
            if((y_cnt == fig_hdiv2) && (x_cnt > line_left) && (x_cnt < line_right))
            begin
                h2_reg0 <= h2_reg1;
                h2_reg1 <= h2_reg2;
                h2_reg2 <= h2_reg3;
                h2_reg3 <= bin;
            end
        end
    end
    
    // ��ֱ�����߽������
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            vcnt <= 4'b0;
        // �µ�һ֡��ʼ
        else if((x_cnt == 1) && (y_cnt == 1))
            vcnt <= 4'b0;
        else if(clken)
        begin
            // ��Ӽ������ص����Լ�С����
            if(v_reg0 == 0 && v_reg1 == 0 && v_reg2 == 0 && v_reg3 == 1 
            && (x_cnt == fig_vdiv) 
            && (y_cnt > line_top) && (y_cnt < line_bottom))
            begin
                vcnt <= vcnt + 1;
            end
        end
    end
    
    // ˮƽ��һ�����߽������
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            hcnt1 <= 4'b0;
        // �µ�һ֡��ʼ
        else if((x_cnt == 1) && (y_cnt == 1))
            hcnt1 <= 4'b0;
        else if(clken)
        begin
           //��Ӽ������ص����Լ�С����
           if(h1_reg0 == 0 && h1_reg1 == 0 && h1_reg2 == 0 && h1_reg3 == 1 
           && (y_cnt == fig_hdiv1) 
           && (x_cnt > line_left) && (x_cnt < line_right))
           begin
               hcnt1 <= hcnt1 + 1;
               h1_pst = (x_cnt < fig_vdiv);
           end
        end
    end
    
    // ˮƽ�ڶ������߽������
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            hcnt2 <= 4'b0;
        // �µ�һ֡��ʼ
        else if((x_cnt == 1) && (y_cnt == 1))
            hcnt2 <= 4'b0;
        else if(clken)
        begin
           //��Ӽ������ص����Լ�С����
           if(h2_reg0 == 0 && h2_reg1 == 0 && h2_reg2 == 0 && h2_reg3 == 1 
           && (y_cnt == fig_hdiv2) 
           && (x_cnt > line_left) && (x_cnt < line_right))
           begin
               hcnt2 <= hcnt2 + 1;
               h2_pst = (x_cnt < fig_vdiv);
           end
        end
    end
    
    always@(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            v_cnt  <= 4'b0;
            h_cnt1 <= 4'b0;
            h_cnt2 <= 4'b0;
            h1     <= 1'b0;
            h2     <= 1'b0;
        end
        else if(vsync == 0)
        begin
            v_cnt  <= vcnt;
            h_cnt1 <= hcnt1;
            h_cnt2 <= hcnt2;
            h1     <= h1_pst;
            h2     <= h2_pst;
        end
    end
    
endmodule
