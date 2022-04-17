`define Initial 3'b000
`define Start 3'b001
`define Cheat 3'b010
`define Guess 3'b011
`define Type 3'b100
`define Correct 3'b101

module lab06(
    output wire [6:0] DISPLAY,
    output wire [3:0] DIGIT,
    output reg [15:0] LED,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk,
    input wire start,
    input wire cheat
    );
    //add your design here

	parameter [8:0] KEY_CODES [0:20] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		9'b0_0001_1110,	// 2 => 1E
		9'b0_0010_0110,	// 3 => 26
		9'b0_0010_0101,	// 4 => 25
		9'b0_0010_1110,	// 5 => 2E
		9'b0_0011_0110,	// 6 => 36
		9'b0_0011_1101,	// 7 => 3D
		9'b0_0011_1110,	// 8 => 3E
		9'b0_0100_0110,	// 9 => 46
		
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010, // right_3 => 7A
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		9'b0_0111_0101, // right_8 => 75
		9'b0_0111_1101, // right_9 => 7D

		9'b0_0101_1010 // enter => 5A
	};
	
	reg [15:0] nums;
	reg [15:0] next_nums;
	reg [3:0] key_num;
	reg [9:0] last_key;
	reg [2:0] state, next_state;
	reg [7:0] left, right, next_left, next_right;
	reg [7:0] random, cnt;
	reg [15:0] next_LED;
	reg [11:0] count;
	
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	wire clk_div15, cheat_de, start_de;

	clock_divider #(15) cd0 (.clk(clk), .clk_div(clk_div15));
	debounce de0 (.pb_debounced(cheat_de), .pb(cheat), .clk(clk));
	debounce de1 (.pb_debounced(start_de), .pb(start), .clk(clk));

    SevenSegment seven_seg (
		.display(DISPLAY),
		.digit(DIGIT),
		.nums(nums),
		.rst(rst),
		.clk(clk)
	);
    
    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @(posedge clk or posedge rst) begin
		if (rst == 1) begin
			LED = 16'd0;
			left = 8'd0;
			right = {2{4'd9}};
			state = `Initial;
			nums = {4{4'd10}};
		end
		else begin
			LED = next_LED;
			left = next_left;
			right = next_right;
			state = next_state;
			nums = next_nums;
		end
	end

	always@(*) begin
		next_LED = 16'd0;
		next_left = left;
		next_right = right;
		case (state)
			`Initial : begin
				next_state = `Initial;
				next_nums = {4{4'd10}};
				next_left = 8'd0;
				next_right = {2{4'd9}};	
				if (start_de == 1) begin
					next_nums = {{2{4'd0}}, {2{4'd9}}};
					next_state = `Start;
				end
			end
			`Start : begin
				next_nums = nums;
				next_state = `Guess;
			end
			`Cheat : begin
				next_state = `Cheat;
				next_nums = {random, {2{4'd11}}};
				if (cheat_de == 0) begin
					next_state = `Guess;
					next_nums = {left, right};
				end
			end
			`Guess : begin
				next_state = state;
				next_nums = nums; 
				if (cheat_de == 1) begin
					next_state = `Cheat;
					next_nums = {random, {2{4'd11}}};
				end
				if (been_ready && key_down[last_change] == 1'b1) begin
					if (key_num <= 4'd9 && key_num >= 4'd0) begin // press number (1~9)
						next_nums = {{3{4'd11}}, key_num};
						next_state = `Type;
					end
				end
			end
			`Type : begin
				next_state = state;
				next_nums = nums;
				if (been_ready && key_down[last_change] == 1'b1) begin
					if (key_num <= 4'd9 && key_num >= 4'd0) begin // press number (1~9)
						next_nums = {{2{4'd11}}, nums[3:0], key_num};
						next_state = `Type;
					end
					else if (key_num == 4'd10) begin
						if (nums[3:0] == 4'd11 || nums[7:4] == 4'd11) begin
							next_nums = {left, right};
							next_state = `Guess;
						end
						else begin
							if (nums[7:0] == random) begin
								next_nums = {random, random};
								next_state = `Correct;
								next_LED = 16'b1111111111111111;
							end
							else if (nums[7:0] >= right || nums[7:0] <= left) begin
								next_nums = {left, right};
								next_state = `Guess;
							end
							else begin
								if (nums[7:0] > random) begin
									next_left = left;
									next_right = nums[7:0];
									next_nums = {left, nums[7:0]};
									next_state = `Guess;
								end
								else begin
									next_left = nums[7:0];
									next_right = right;
									next_nums = {nums[7:0], right};
									next_state = `Guess;
								end
							end
						end
					end
				end
			end
			`Correct : begin
				next_state = state;
				next_nums = nums;
				next_LED = 16'b1111111111111111;
				if (count == 12'd1024) begin
					next_LED = 16'd0;
					next_nums = {4{4'd10}};
					next_state = `Initial;
				end
			end
		endcase
	end

    always @ (*) begin
		case (last_change)
			KEY_CODES[00] : key_num = 4'b0000;
			KEY_CODES[01] : key_num = 4'b0001;
			KEY_CODES[02] : key_num = 4'b0010;
			KEY_CODES[03] : key_num = 4'b0011;
			KEY_CODES[04] : key_num = 4'b0100;
			KEY_CODES[05] : key_num = 4'b0101;
			KEY_CODES[06] : key_num = 4'b0110;
			KEY_CODES[07] : key_num = 4'b0111;
			KEY_CODES[08] : key_num = 4'b1000;
			KEY_CODES[09] : key_num = 4'b1001;
			KEY_CODES[10] : key_num = 4'b0000;
			KEY_CODES[11] : key_num = 4'b0001;
			KEY_CODES[12] : key_num = 4'b0010;
			KEY_CODES[13] : key_num = 4'b0011;
			KEY_CODES[14] : key_num = 4'b0100;
			KEY_CODES[15] : key_num = 4'b0101;
			KEY_CODES[16] : key_num = 4'b0110;
			KEY_CODES[17] : key_num = 4'b0111;
			KEY_CODES[18] : key_num = 4'b1000;
			KEY_CODES[19] : key_num = 4'b1001;
			KEY_CODES[20] : key_num = 4'b1010;
			default		  : key_num = 4'b1111;
		endcase
	end

	always @(posedge clk_div15) begin
		case (state) 
			`Correct : begin
				count <= count + 12'd1;
			end
			default begin
				count <= 12'd0;
			end
		endcase
	end

	always @(posedge clk) begin
		case (state)
			`Start : begin
				random[7:4] = cnt / 7'd10;
				random[3:0] = cnt % 7'd10;
			end
			default begin
				random = random;
			end
		endcase
	end

	always @(posedge clk) begin
		if (cnt == 7'd98) begin
			cnt <= 7'd1;
		end
		else begin
			cnt <= cnt + 7'd1;
		end
	end

endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; // output after being debounced
    input pb; // input from a pushbutton
    input clk;
    reg [3:0] shift_reg; // use shift_reg to filter the bounce
    always @(posedge clk)
        begin
        shift_reg[3:1] <= shift_reg[2:0];
        shift_reg[0] <= pb;
    end
    assign pb_debounced = ((shift_reg == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module clock_divider(clk, clk_div);
    parameter n = 26;
    input clk;
    output clk_div;

    reg [n-1:0] num;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num = next_num;
    end

    assign next_num = num+1;
    assign clk_div = num[n-1];
endmodule