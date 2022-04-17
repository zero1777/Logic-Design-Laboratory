module lab2_1(clk, rst_n, en, dir, in, data, out); 
	input clk, rst_n, en, dir, in;
	input [3:0] data;
	output [3:0] out;
	reg [3:0] out;

	always @(posedge clk or negedge rst_n) begin
		if (rst_n == 1'b0) begin
			out = 4'b0000;
		end
		else begin // rst_n == 1
			if (en == 1'b1) begin // enable
				if (in == 1'b0) begin 
					if (dir == 1'b1) begin // count UP
						out = (out == 4'b1111) ? 4'b0000 : out + 1;
					end
					else begin // count DOWN
						out = (out == 4'b0000) ? 4'b1111 : out - 1;
					end
				end
				else begin // assign data into out
					out = data;
				end
			end
			else begin // disable
				out = out;
			end
		end
	end

endmodule

