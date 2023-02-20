`timescale 1ns / 1ps

// ����ͷ��ʼ��
module camera_init_top(
    input clk,      // 25MHzʱ��
    input reset,    // ��λ�ź�
    // ������������ͷ�����Ĺܽ�
    output sio_c,
    inout  sio_d,
    output pwdn,
    output ret,
    output xclk
    );
    
    // pwdn�ߵ�ƽ��Ч ret�͵�ƽ��Ч
    assign pwdn = 0;
    assign ret = 1;
    // sio_d����̬
    pullup up (sio_d);
    // ����xclkʱ���ź�    
    assign xclk = clk;
    
    wire cfg_ok, sccb_ok;
    wire [15: 0] data_sent;
    
    // ʵ��������д��ģ��
    camera_reg_cfg reg_cfg(
        .clk(clk),
        .reset(reset),
        .data_out(data_sent),
        .cfg_ok(cfg_ok),
        .sccb_ok(sccb_ok)
    );
    
    // ʵ����sccb����ģ��
    camera_sccb_sender sccb_sender(
        .clk(clk),
        .reset(reset),
        .sio_c(sio_c),
        .sio_d(sio_d),
        .cfg_ok(cfg_ok),
        .sccb_ok(sccb_ok),    
        .reg_addr(data_sent[15:8]),   
        .value(data_sent[7:0])      
    );
   
    
endmodule
