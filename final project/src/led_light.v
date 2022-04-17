`define WAIT 3'b000
`define PAY 3'b001
`define SEND_PROCESS 3'b010

module led_light(
    input clk,
    input rst,
    input [2:0] state,
    output reg [15:0] led
);

    reg [15:0] next_led;
    wire clk_div26;

    clock_divider #(26) cd0(.clk(clk), .clk_div(clk_div26));

    always @(posedge clk_div26, posedge rst) begin
        if (rst) begin
            led = 16'd0;
        end
        else begin
            led = next_led;
        end
    end

    always @(*) begin
        case (state)
            `SEND_PROCESS : begin
                if (led == 16'd0) begin
                    next_led = {8{2'b01}};
                end
                else begin
                    next_led = {led[0], led[15:1]};
                end
            end 
            default: begin
                next_led = 16'd0;
            end
        endcase
    end

endmodule 