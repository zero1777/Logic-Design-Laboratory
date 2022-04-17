`timescale 1ns / 100ps

module lab2_3_t();
	reg clk, rst_n, pass;
	wire out;
	reg [5:0] F;
	lab2_3 LFSR(.clk(clk), .rst_n(rst_n), .out(out)); 

	initial begin
		clk = 0;
		rst_n = 1;
		pass = 1;		
		#3
		rst_n = 0;
		F = 6'b000001;
		#4
		rst_n = 1;
		#1000
		if (pass)
		      $display("---- Pass ----");
		else
		      $display("---- Wrong ----");
		$finish;
	end

	always begin
		#5 clk = ~clk;
		if (out != F[5]) begin
          pass = 0;
        end	
	end
	
	always @(posedge clk) begin
	   if (rst_n == 1) begin
            F = {F[4:0], F[0]^F[5]};
        end
	end
endmodule