module uart_rx #(
    parameter BAUD_FLAG_MAX = 13'd5207,
    parameter BIT_CNT_MAX = 4'd9
)(
    input wire sys_clk,
    input wire sys_rst_n,
    input wire rx,
    output reg [7:0] po_data,
    output reg po_data_flag
);
    
    reg rx_reg;
    reg rx_reg2;
    reg rx_reg3;    
    reg nedge_flag;
    reg work_en;
    reg [12:0] baud_count;
    reg bit_flag;
    reg [3:0] bit_cnt;
    reg [7:0] rx_data;
    reg rx_data_flag;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            rx_reg <= 1'b0;
        else
            rx_reg <= rx;
    end
    
    //delay 2 clock-period to figure out metastable state
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            rx_reg2 <= 1'b0;
        else
            rx_reg2 <= rx_reg;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            rx_reg3 <= 1'b0;
        else 
            rx_reg3 <= rx_reg2;
    end

    //detect negative edge of rx_reg3
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            nedge_flag <= 1'b0;
        else if((~rx_reg2) && (rx_reg3))
            nedge_flag <= 1'b1;
        else
            nedge_flag <= 1'b0;
    end

    //when the first nedge_flag=1, it means that uart_rx begins to receive data. At this moment set a "enable signal" to 1.
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            work_en <= 1'b0;
        else if(nedge_flag == 1'b1)
            work_en <= 1'b1;
        else if((bit_cnt == BIT_CNT_MAX) && (bit_flag == 1'b1))
            work_en <= 1'b0;
    end

    //It takes baud_count 0~5207 for rx to receive every one bit
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            baud_count <= 13'd0;
        else if((work_en == 1'b0) || (baud_count == BAUD_FLAG_MAX))
            baud_count <= 13'd0;
        else if(work_en == 1'b1)
            baud_count <= baud_count + 1'b1;
    end

    //when count to 2603, set a pulse bit_flag to pick the value of rx easily
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            bit_flag <=  1'b0;
        else if(baud_count == BAUD_FLAG_MAX/2)
            bit_flag <= 1'b1;
        else
            bit_flag <= 1'b0;
    end 

    //set a sequence of the data, to avoid pick start bit and stop bit
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            bit_cnt <= 4'd0;
        else if((bit_flag == 1'b1) && (bit_cnt == BIT_CNT_MAX))
            bit_cnt <= 4'd0;
        else if(bit_flag == 1'b1)
            bit_cnt <= bit_cnt + 1'b1;
    end

    //pick the data and transform the serie to parallel data
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            rx_data <= 8'b0000_0000;
        else if((bit_cnt >= 1'b1) && (bit_cnt <= BIT_CNT_MAX - 1'b1) && (bit_flag == 1'b1))
            rx_data <= {rx, rx_data[7:1]};
    end

    //after transformation, send a pulse
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(sys_rst_n == 1'b0)
            rx_data_flag <= 1'b0;
        else if((bit_cnt == BIT_CNT_MAX) && (bit_flag == 1'b1))
            rx_data_flag <= 1'b1;
        else
            rx_data_flag <= 1'b0;
    end

    // output data
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            po_data <= 8'b0000_0000;
        else if (rx_data_flag == 1'b1)
            po_data <= rx_data;
    end

    // output flag
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            po_data_flag <= 1'b0;
        else
            po_data_flag <= rx_data_flag;
    end
endmodule