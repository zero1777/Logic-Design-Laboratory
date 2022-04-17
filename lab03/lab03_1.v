module lab03_1(clk, rst, en, dir, led);
    input clk;
    input rst;
    input en;
    input dir;
    output [15:0] led;
    reg [15:0] led;

    reg [15:0] next_led;
    wire clk_div;

    clock_divider cd0(.clk(clk), .clk_div(clk_div));

    always @(posedge clk_div) begin
        if (rst == 1) begin
            led = {1'b1, 15'b0};
        end
        else begin
            if (en == 1) begin
                led = next_led;
            end
            else begin
                led = led;
            end
        end
    end

    always @(*) begin
        if (dir == 1) begin
            next_led = {led[14:0], led[15]};
        end
        else begin
            next_led = {led[0], led[15:1]};
        end
    end

endmodule