`timescale 1ns / 1ps

module horizontal_projection(
	input				clk,                // ����ʱ��
	input				reset,              // ��λ�ź�
	input				vsync,              // ֡ͬ��
	input				href,               // �вο�
	input				clken,              // ����ʹ��
	input				bin,                // ����Ķ�ֵ��bit�źţ���ɫΪ1����ɫΪ0��
	input      [10:0]   line_left,          // �������ҿ���
	input      [10:0]   line_right,
    output reg [10:0] 	line_top,           // �������¿���
    output reg [10:0] 	line_bottom
);

	parameter	DISPLAY_WIDTH  = 10'd640;
	parameter	DISPLAY_HEIGHT = 10'd480;

    /*********************
        ������Ĵ�������
    *********************/
    
    // �г�����
    reg [10:0]  	x_cnt;      
    reg [10:0]      y_cnt;
    
    // �Ĵ���ˮƽͶӰ
    reg [9:0]       tot;       
    reg [9:0]       tot1;
    reg [9:0]       tot2;
    reg [9:0]       tot3;
    
    // �Ĵ��������½���λ��
    reg [10:0]      topline1;
    reg [10:0]      bottomline1;


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

    // ÿһ�н��м���  
    always@(posedge clk or posedge reset)
    begin
        if(reset)
            tot <= 10'b0;
        else if(clken)
        begin
            if(x_cnt == 0)
                tot <= 10'b0;
            // ֻ�����ַ�Χ�ڽ���ͶӰ
            else if(x_cnt > line_left && x_cnt < line_right)
                tot <= tot + bin;
        end
    end

    // �Ĵ�3�� ���ں����ж������½���
    always @ (posedge clk or posedge reset) 
    begin
        if(reset) 
        begin
            tot1 <= 10'd0;
            tot2 <= 10'd0;
            tot3 <= 10'b0;
        end
        else if(clken && x_cnt == DISPLAY_WIDTH - 1) 
        begin
            tot1 <= tot;
            tot2 <= tot1;
            tot3 <= tot2;
        end
    end
    
    always @ (posedge clk or posedge reset) 
    begin
        if(reset) 
        begin
            topline1    <= 10'd0;
            bottomline1 <= 10'd0;
        end
        else if(clken) 
        begin
            // ���һ�п�ʼͳ�������½���
            if(x_cnt == DISPLAY_WIDTH - 1'b1) 
            begin    
                if((tot3 == 10'd0) && (tot > 10'd10))
                    topline1 <= y_cnt - 3;            
                
                if((tot3 > 10'd10) && (tot == 10'd0))
                    bottomline1 <= y_cnt - 3;
            end
        end
    end
    
    // һ֡д����Ϻ� �ٸ�������λ��
    always @ (posedge clk or posedge reset) 
    begin
        if(reset) 
        begin
            line_top    <= 10'd0;
            line_bottom <= 10'd0;
        end
        else if(vsync == 0) 
        begin
            line_top    <= topline1;
            line_bottom <= bottomline1;
        end  
    end

endmodule
