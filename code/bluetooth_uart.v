`timescale 1ns / 1ps

// ������Ϣ����
module bluetooth_uart_receive(
    input clk,                      // ϵͳʱ��
    input reset,                    // ��λ�ź�
    input rxd,                      // ������������
    output reg [7:0] data_out,      // �����������
    output reg data_flag            // ������������ź�
    );

    parameter CLK_FREQ = 100000000;            // ϵͳʱ��Ƶ��
    parameter UART_BPS = 9600;                 // ���ڲ�����
    localparam BPS_CNT = CLK_FREQ / UART_BPS;
 
	// �Ĵ�������������
    reg rxd_reg1;		// ������ ��������̬
    reg rxd_reg2;
	reg rxd_reg3;
	wire start_flag;	// �ȶ��½����ź�
    reg [14:0] clk_cnt;
    reg [3:0] bit_cnt;
    reg work_flag;		// ��ʼ8bit�Ĵ�ת��
    reg [7:0] rx_data;

	// �ȶ��½��� ��ʼ����
    assign start_flag = (~rxd_reg2) & rxd_reg3;    

    always @(posedge clk or negedge reset) 
	begin 
        if(reset) 
            { rxd_reg1, rxd_reg2, rxd_reg3 } <= 3'b111;     
        else 
            { rxd_reg1, rxd_reg2, rxd_reg3 } <= { rxd, rxd_reg1, rxd_reg2 };  
    end

    // ��ʼ����8bit�źŵ�����
    always @(posedge clk or negedge reset) 
	begin         
        if(reset)                                  
            work_flag <= 1'b0;
        else 
		begin
			// ��ʼ����8bit
            if(start_flag)
                work_flag <= 1'b1;
			// ��ǰ8bit������� �ȴ����ź�
            else if((bit_cnt == 9) && (clk_cnt == BPS_CNT / 2))
                work_flag <= 1'b0;
            else
                work_flag <= work_flag;
        end
    end
    
    // ���ݲ�������ʱ��Ƶ�ʼ�ʱ
    always @(posedge clk or negedge reset) 
	begin         
        if(reset) 
		begin                             
            clk_cnt <= 0;                                  
            bit_cnt <= 0;
        end 
		else if(work_flag) 
		begin
			if(clk_cnt < BPS_CNT - 1) 
			begin
				clk_cnt <= clk_cnt + 1'b1;
				bit_cnt <= bit_cnt;
			end 
			else 
			begin
				clk_cnt <= 0;
				bit_cnt <= bit_cnt + 1'b1;
			end
		end 
		else 
		begin
			clk_cnt <= 0;
			bit_cnt <= 0;
		end
    end
    
    // ��������ת����
    always @(posedge clk or negedge reset) 
	begin 
        if(reset)  
            rx_data <= 8'b0;                                     
        else if(work_flag)
			// �������ж�����ȶ� У��λ����
            if(clk_cnt == BPS_CNT / 2 && bit_cnt != 9) 
				rx_data <= { rxd_reg3, rx_data[7:1] };
            else 
                rx_data <= rx_data;
        else
            rx_data <= 8'b0;
    end
        
	// 8bit���ͽ��� �������
    always @(posedge clk or negedge reset) 
	begin        
        if(reset)
            data_out <= 8'b0;                               
        else if(bit_cnt == 9)    
            data_out <= rx_data; 
		else
			data_out <= data_out;
    end

	// �����־λ����
    always @(posedge clk or negedge reset) 
	begin        
        if(reset)                            
            data_flag <= 0;
        else if(bit_cnt == 9) 
            data_flag <= 1;
        else                                 
            data_flag <= 0; 
    end

endmodule