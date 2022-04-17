module lab2_3 (clk, rst_n, out); 
	input clk, rst_n;
	output reg out;
    reg [5:0] F;

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			// reset
			F = 6'b000001;
		end
		else begin
			F = {F[4:0], F[0]^F[5]};
			out = F[5];
		end
	end
endmodule