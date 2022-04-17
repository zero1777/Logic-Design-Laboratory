`timescale 1ns / 100ps

module lab2_1_t();
	reg clk, rst_n, en, dir, in;
	reg [3:0] data;
	wire [3:0] out;
	
	lab2_1 counter(.clk(clk), .rst_n(rst_n), .en(en), .dir(dir), .in(in), .data(data), .out(out));

	initial begin
		clk = 0;
		rst_n = 1;
		en = 0;
		dir = 1;
		in = 0;
		data = 0;
		#3
		rst_n = 0;
		#4
		rst_n = 1;
		#20
		en = 1;
		#500
		dir = 0;
		#500
		in = 1;
		data = 4'b0111;
        #20
        $finish;
	end

	always begin
		#5 clk = ~clk;
	end
endmodule