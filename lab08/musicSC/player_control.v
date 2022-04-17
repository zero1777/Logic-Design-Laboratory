module player_control (
	input clk,
	input reset,
	input _play,
	input _repeat,
	input _music,
//	input [14:0] LEN,
	output reg [11:0] ibeat
);
    reg [14:0] next_ibeat;
	reg check;
	reg [14:0] LEN;

	// always @(posedge clk, posedge reset) begin
	// 	if (reset)
	// 		ibeat <= 0;
	// 	else begin
    //         ibeat <= next_ibeat;
	// 	end
	// end

    always @* begin
		if (_play) begin
			next_ibeat = (ibeat + 1 < LEN) ? (ibeat + 1) : ((_repeat) ? 15'd0 : ibeat);
		end
		else begin
			next_ibeat = ibeat;
		end
    end

	always @(posedge clk, posedge reset) begin
		if (reset) begin
			check = 1'b0;
			ibeat = 0;
		end
		else begin
			ibeat = next_ibeat;
			if (_music) begin
				check = check;
				if (check == 1'b0) begin
					check = 1'b1;
					ibeat = 0;
				end
			end
			else begin
				check = check;
				if (check == 1'b1) begin
					check = 1'b0;
					ibeat = 0;
				end
			end
		end
	end

    always @(*) begin
        if (_music) begin
            LEN = 15'd1217;
        end
        else begin
            LEN = 15'd513;
        end
    end

endmodule