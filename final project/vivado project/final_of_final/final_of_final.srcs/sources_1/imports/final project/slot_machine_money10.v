module slot_machine_money10(
    input clk,
	input rst,
	input signal,
	output mny10
	);

	
	// reg [6:0] count ,next_count;
	// reg [15:0] num;
	wire signal_, clk_div16, signal_de;

	clock_divider #(16) cd0 (.clk(clk), .clk_div(clk_div16));

    debounce de0 (.pb_debounced(signal_de), .pb(signal), .clk(clk_div16));

    OnePulse op0 (
    .signal_single_pulse(signal_),
	.signal(signal_de),
    .clock(clk_div16)
	);
	// always @(posedge clk_div16 or posedge rst) begin
	// 	if (rst) begin
	// 		count <= 0;
	// 	end
	// 	else begin
	// 		count <= next_count;
	// 	end
	// end
	// always @(*) begin
	// 	if(signal_ == 1) begin
	// 		if(count < 99) 
	// 			next_count = count + 5;
	// 		else     
	// 			next_count = 0;
	// 	end
	// 	else begin
	// 		next_count = count;
	// 	end
	// end

	assign mny10 = (signal_) ? 1'b1 : 1'b0;

endmodule