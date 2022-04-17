`define WAIT 3'b000
`define PAY 3'b001
`define SEND_PROCESS 3'b010

`define LEFT 2'b00
`define MIDDLE 2'b01
`define RIGHT 2'b10

module position_gen(
    input rst,
    input clk,
    input left,
    input right,
    input [2:0] state,
    output reg [1:0] pos
);

    reg [1:0] next_pos;
    wire clk_div16, left_de, lf, right_de, rg;

    clock_divider #(16) cd0(.clk(clk), .clk_div(clk_div16));

    debounce de0 (.pb_debounced(left_de), .pb(left), .clk(clk_div16));
    debounce de1 (.pb_debounced(right_de), .pb(right), .clk(clk_div16));

    OnePulse op0 (
	.signal_single_pulse(lf),
	.signal(left_de),
	.clock(clk_div16)
	);

    OnePulse op1 (
	.signal_single_pulse(rg),
	.signal(right_de),
	.clock(clk_div16)
	);

    always @(posedge clk_div16 or posedge rst) begin
        if (rst)
            pos = `MIDDLE;
        else
            pos = next_pos;
    end

    always @(*) begin
        if (state == `WAIT) begin
            case (pos)
                `LEFT : begin
                    if (rg) next_pos = `MIDDLE;
                    else next_pos = pos;
                end
                `MIDDLE : begin
                    if (rg) next_pos = `RIGHT;
                    else if (lf) next_pos = `LEFT;
                    else next_pos = pos;
                end 
                `RIGHT : begin
                    if (lf) next_pos = `MIDDLE;
                    else next_pos = pos;
                end
            endcase
        end
        else begin
            next_pos = pos;
        end
    end

endmodule
