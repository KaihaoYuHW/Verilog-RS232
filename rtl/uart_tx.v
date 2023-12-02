module uart_tx #(
    parameter BAUD_CNT_MAX = 13'd5207
) (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire [7:0] pi_data,
    input wire pi_data_flag,
    output reg tx
);
    
    reg work_en;
    reg [12:0] baud_cnt;
    reg bit_flag;
    reg [3:0] bit_cnt;

    //when pi_data_flag=1, it means the parallel data is steady and we can deal with it.
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            work_en <= 1'b0;
        else if (pi_data_flag == 1'b1)
            work_en <= 1'b1;
        else if ((bit_flag == 1'b1) && (bit_cnt == 4'd9))
            work_en <= 1'b0;
    end

    //It takes baud_count for tx to send every single bit of the parallel data
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            baud_cnt <= 13'd0;
        else if ((baud_cnt == BAUD_CNT_MAX) || (work_en == 1'b0))
            baud_cnt <= 13'd0;
        else if (work_en == 1'b1)
            baud_cnt <= baud_cnt + 1'b1;
    end

    //when count to 1, set a pulse bit_flag to send a bit
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            bit_flag <= 1'b0;
        else if (baud_cnt == 13'd1)
            bit_flag <= 1'b1;
        else 
            bit_flag <= 1'b0;
    end

    //set a sequence of the data including start bit, but dont need stop bit 
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            bit_cnt <= 4'd0;
        else if ((bit_flag == 1'b1) && (bit_cnt == 4'd9))
            bit_cnt <= 4'd0;
        else if (bit_flag == 1'b1)
            bit_cnt <= bit_cnt + 1'b1;
    end

    //transform the paralle to serial data and send out
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (sys_rst_n == 1'b0)
            tx <= 1'b1;
        else if (bit_flag == 1'b1)
            case (bit_cnt)
                0: tx <= 1'b0;
                1: tx <= pi_data[0];
                2: tx <= pi_data[1];
                3: tx <= pi_data[2];
                4: tx <= pi_data[3];
                5: tx <= pi_data[4];
                6: tx <= pi_data[5];
                7: tx <= pi_data[6];
                8: tx <= pi_data[7];
                9: tx <= 1'b1;
                default: tx <= 1'b1;
            endcase
    end
endmodule