`timescale 1ns / 1ps

// ����ͷ���仭��
module camera_get_img(
    input               pclk,           // 1��������Ϊ2��pclk
    input               reset,          // ��λ�ź�
    input               href,           // �вο��ź�
    input               vsync,          // ֡ͬ��
    input      [7:0]    data_in,        // ������ͷ�����RGB565��Ϣ(����pclk)
    output reg [11:0]   data_out,      // �����һ����RGB444
    output reg          pix_ena,       // �µ��������
    output reg [18:0]   ram_out_addr   // Ӧ��д���RAM��ַ
);

    reg [15:0] rgb565 = 0;
    reg [1:0]  bit_status = 0;     // ����pclk��Ӧһ�����
    reg [18:0] ram_next_addr;
    
    initial ram_next_addr <= 0;
    
    always@ (posedge pclk) 
    begin
        // ��ʼ����µ�һ֡ ��ͷд��RAM
        if(vsync == 0) 
        begin
            ram_out_addr <= 0;
            ram_next_addr <= 0;
            bit_status <= 0;
        end 
        else 
        begin
            // RGB565ȡ��λѹ��ΪRGB444
            data_out <= { rgb565[15:12], rgb565[10:7], rgb565[4:1] };
            ram_out_addr <= ram_next_addr;
            pix_ena <= bit_status[1];
            // ����pclk���һ��
            bit_status <= {bit_status[0], (href && !bit_status[0])};
            // ���ֽ���Ϣ ƴ��16bit��RGB565
            rgb565 <= { rgb565[7:0], data_in };    
            if(bit_status[1] == 1)
                ram_next_addr <= ram_next_addr + 1;
        end
    end
    
endmodule


