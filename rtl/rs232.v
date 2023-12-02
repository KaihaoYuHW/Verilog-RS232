module rs232 (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire rx,
    output wire tx
);

    parameter BAUD_FLAG_MAX = 13'd5207;
    parameter BIT_CNT_MAX = 4'd9;

    wire [7:0] p_data;
    wire p_data_flag;
    
    uart_rx #(
        .BAUD_FLAG_MAX(BAUD_FLAG_MAX),
        .BIT_CNT_MAX(BIT_CNT_MAX)
    ) uart_rx_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .rx(rx),
        .po_data(p_data),
        .po_data_flag(p_data_flag)
    );

    uart_tx #(
        .BAUD_CNT_MAX(BAUD_FLAG_MAX)
    ) uart_tx_inst (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .pi_data(p_data),
        .pi_data_flag(p_data_flag),
        .tx(tx)
    );

endmodule