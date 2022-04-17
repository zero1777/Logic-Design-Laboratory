`define WAIT 3'b000
`define PAY 3'b001
`define SEND_PROCESS 3'b010

`define LEFT 2'b00
`define MIDDLE 2'b01
`define RIGHT 2'b10

module display(
    input rst,
    input clk,
    input select,
    input money_5,
    input money_10,
    input confirm,
    input complete,
    input [1:0] pos,
    output reg [2:0] state,
    output [15:0] nums,
    output reg get_beverage, // send signal to vending machine
    output music
);
    reg [7:0] balance, next_balance, countdown, next_countdown;
    wire [3:0] d1, d2, d3, d4;

    reg [2:0] next_state;
    reg [10:0] cnt;

    wire clk_div16;
    wire select_de, slct, money5_de, mny5, money10_de, mny10;
    wire complete_de, complete_op;

    CreateLargePulse clp0 (
        .large_pulse(complete_op),
        .small_pulse(complete),
        .rst(rst),
        .clk(clk)
    );

    clock_divider #(16) cd0(.clk(clk), .clk_div(clk_div16));

    debounce de0 (.pb_debounced(select_de), .pb(select), .clk(clk_div16));
    debounce de1 (.pb_debounced(money5_de), .pb(money_5), .clk(clk_div16));
    debounce de2 (.pb_debounced(money10_de), .pb(money_10), .clk(clk_div16));
    // debounce de5 (.pb_debounced(complete_de), .pb(complete), .clk(clk_div16));

    OnePulse op0 (
	.signal_single_pulse(slct),
	.signal(select_de),
	.clock(clk_div16)
	);

    OnePulse op1 (
	.signal_single_pulse(mny5),
	.signal(money5_de),
	.clock(clk_div16)
	);

    OnePulse op2 (
	.signal_single_pulse(mny10),
	.signal(money10_de),
	.clock(clk_div16)
	);

    // OnePulse op5 (
	// .signal_single_pulse(complete_op),
	// .signal(complete_de),
	// .clock(clk_div16)
	// );

    always @(posedge clk_div16 or posedge rst) begin
        if (rst) begin
            state = `WAIT;
            balance = 8'd0;
            countdown = 8'd40;
        end
        else begin
            state = next_state;
            balance = next_balance;
            countdown = next_countdown;
        end
    end

    always @(*) begin
        get_beverage = 1'b0;
        next_state = state;
        next_balance = balance;
        next_countdown = countdown;
        case (state)
            `WAIT : begin
                if (slct) begin
                    next_state = `PAY;
                    next_balance = 8'd0;
                    next_countdown = 8'd40;
                end
            end 
            `PAY : begin
                if (mny5) begin
                    next_balance = (balance <= 8'd90) ? balance + 8'd5 : 8'd95;
                end
                else if (mny10) begin
                    next_balance = (balance <= 8'd85) ? balance + 8'd10 : 8'd95;
                end
                if (cnt == 11'd1800) begin
                    if (countdown == 8'd0) begin
                        if (pos == `LEFT) begin
                            if (balance >= 8'd35) begin
                                get_beverage = 1'b1;
                                next_balance = balance - 8'd35;
                                next_state = `SEND_PROCESS;
                                next_countdown = 8'd0;
                            end
                            else begin
                                next_state = `WAIT;
                                next_balance = 8'd0;
                                next_countdown = 8'd40;
                            end
                        end
                        else if (pos == `MIDDLE) begin
                            if (balance >= 8'd30) begin
                                get_beverage = 1'b1;
                                next_balance = balance - 8'd30;
                                next_state = `SEND_PROCESS;
                                next_countdown = 8'd0;
                            end
                            else begin
                                next_state = `WAIT;
                                next_balance = 8'd0;
                                next_countdown = 8'd40;
                            end
                        end
                        else if (pos == `RIGHT) begin
                            if (balance >= 8'd40) begin
                                get_beverage = 1'b1;
                                next_balance = balance - 8'd40;
                                next_state = `SEND_PROCESS;
                                next_countdown = 8'd0;
                            end
                            else begin
                                next_state = `WAIT;
                                next_balance = 8'd0;
                                next_countdown = 8'd40;
                            end
                        end
                    end
                    else begin
                        next_countdown = countdown - 1;
                    end
                end
                if (confirm) begin
                    if (pos == `LEFT) begin
                        if (balance >= 8'd35) begin
                            get_beverage = 1'b1;
                            next_balance = balance - 8'd35;
                            next_state = `SEND_PROCESS;
                            next_countdown = 8'd0;
                        end
                    end
                    else if (pos == `MIDDLE) begin
                        if (balance >= 8'd30) begin
                            get_beverage = 1'b1;
                            next_balance = balance - 8'd30;
                            next_state = `SEND_PROCESS;
                            next_countdown = 8'd0;
                        end
                    end
                    else if (pos == `RIGHT) begin
                        if (balance >= 8'd40) begin
                            get_beverage = 1'b1;
                            next_balance = balance - 8'd40;
                            next_state = `SEND_PROCESS;
                            next_countdown = 8'd0;
                        end
                    end
                end
            end
            `SEND_PROCESS : begin
                if (complete_op) begin
                    next_state = `WAIT;
                end
                else begin
                    next_state = state;
                end
            end
        endcase
    end

    always @(posedge clk_div16 or posedge rst) begin
        if (rst) 
            cnt = 11'd0;
        else begin
            case (state)
                `PAY : cnt = (cnt == 11'd1800) ? 11'd0 : cnt + 1;
                default: cnt = 11'd0; 
            endcase
        end 
    end

    assign nums = {d1, d2, d3, d4};
    assign d1 = (state == `WAIT) ? 4'd10 : balance / 8'd10;
    assign d2 = (state == `WAIT) ? 4'd10 : balance % 8'd10;
    assign d3 = (state == `WAIT) ? 4'd10 : countdown / 8'd10;
    assign d4 = (state == `WAIT) ? 4'd10 : countdown % 8'd10;

    assign music = (state == `PAY) ? 1'b1 : 1'b0;
    //assign get_beverage = (state == `SEND_PROCESS) ? 1'b1 : 1'b0;

endmodule
