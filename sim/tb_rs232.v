`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:35:06 11/27/2023
// Design Name:   rs232
// Module Name:   E:/IC_design/Verilog/fuxi/rs232/sim/tb_rs232.v
// Project Name:  rs232
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rs232
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_rs232;

	// Inputs
	reg sys_clk;
	reg sys_rst_n;
	reg rx;

	// Outputs
	wire tx;

	// Instantiate the Unit Under Test (UUT)
	rs232 uut (
		.sys_clk(sys_clk), 
		.sys_rst_n(sys_rst_n), 
		.rx(rx), 
		.tx(tx)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		rx <= 1'b1;
		#20;
		sys_rst_n <= 1'b1;
	end

	initial begin
		#200;
		rx_bit(8'd0);
		rx_bit(8'd1);
		rx_bit(8'd2);
		rx_bit(8'd3);
		rx_bit(8'd4);
		rx_bit(8'd5);
		rx_bit(8'd6);
		rx_bit(8'd7);
	end

	always #10 sys_clk = ~sys_clk;

	task rx_bit(
		input [7:0] data	
	);
		integer i;
		for (i=0; i<10; i=i+1) begin
			case (i)
				0: rx <= 1'b0;		//start bit
				1: rx <= data[0];
				2: rx <= data[1];
				3: rx <= data[2];
				4: rx <= data[3];
				5: rx <= data[4];
				6: rx <= data[5];
				7: rx <= data[6];
				8: rx <= data[7];
				9: rx <= 1'b1;		//end bit
				default: rx <= 1'b1;
			endcase
			#(5208*20);
		end
	endtask
      
endmodule

