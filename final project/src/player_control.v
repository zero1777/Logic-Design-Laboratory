module player_control (
	input clk,
	input reset,
    input music,
	output reg [11:0] ibeat
);
	wire [9:0] LEN;
    reg [11:0] next_ibeat;
	reg check;

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			check <= 1'b0;
			ibeat <= 0;
		end
		else begin
            ibeat <= next_ibeat;
			if (music) begin
				check <= check;
				if (!check) begin
					ibeat <= 0;
					check <= 1'b1;
				end
			end
			else begin
				check <= check;
				if (check) begin
					ibeat <= 0;
					check <= 1'b0;
				end
			end
		end
	end

    always @* begin
        next_ibeat = (ibeat < LEN) ? (ibeat + 1) : 12'd0;
    end

    assign LEN = (music) ? 10'd479 : 10'd239;

endmodule