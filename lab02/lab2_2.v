module lab2_2(clk, rst_n, en, dir, gray, cout); 
	input clk, rst_n, en, dir;
	output [7:0] gray; 
	output cout;
	wire tmp_cout;

	one_digit_graycode odg0(.clk(clk), .rst_n(rst_n), .en(en), .dir(dir), .gray(gray[3:0]), .cout(tmp_cout));
	one_digit_graycode odg1(.clk(clk), .rst_n(rst_n), .en(tmp_cout), .dir(dir), .gray(gray[7:4]), .cout(cout));
 
endmodule

module one_digit_graycode(clk, rst_n, en, dir, gray, cout);
	input clk, rst_n, en, dir;
	reg [3:0] bin_count;
	output reg [3:0] gray; 
	output cout;

	always @(negedge clk, negedge rst_n) begin
		if (rst_n == 1'b0) begin
			gray = 4'b0000;
			bin_count = 4'b0000;
		end
		else begin // rst_n == 1
			if (en == 1'b1) begin // enable
				if (dir == 1'b1) begin // count UP
					bin_count = bin_count + 1'b1;  
					gray = {bin_count[3], bin_count[3]^bin_count[2], bin_count[2]^bin_count[1], bin_count[1]^bin_count[0]};
				end
				else begin // count DOWN
					bin_count = bin_count - 1'b1;   
					gray = {bin_count[3], bin_count[3]^bin_count[2], bin_count[2]^bin_count[1], bin_count[1]^bin_count[0]};
				end
			end
			else begin // disable
				gray = gray;
				bin_count = bin_count;
			end
		end
	end
	assign cout = ((gray==4'b1000 && dir==1'b1 && en==1) || (gray==4'b0000 && dir==1'b0 && en==1)) ? 1'b1 : 1'b0 ;

endmodule