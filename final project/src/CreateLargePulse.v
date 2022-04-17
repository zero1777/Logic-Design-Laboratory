module CreateLargePulse(
	output wire large_pulse,
	input wire small_pulse,
	input wire rst,
	input wire clk
);
	reg [15:0] count, next_count;
	reg state, next_state;
	always@(posedge clk or posedge rst) begin
		if(rst) begin
			count <= 16'd0;
			state <= 1'b0;
		end
		else begin
			count <= next_count;
			state <= next_state;
		end
	end
	
	always@(*) begin
		case(state)
			0:begin
				//waiting
				if(small_pulse == 0) begin
					next_state = 0;
					next_count = 0;
				end
				else begin
					next_state = 1;
					next_count = 1;
				end
			end
			1:begin
				//counting
				if(count == 0)begin
					next_state = 0;
					next_count = 0;
				end
				else begin
					next_state = 1;
					next_count = count+1;
				end
			end
		endcase
	end
	
	assign large_pulse = (state == 1'b1)?1'b1:1'b0;
endmodule