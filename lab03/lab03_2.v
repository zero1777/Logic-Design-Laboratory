module lab03_2(clk, rst, en, dir, led);
    input clk;
    input rst;
    input en;
    input dir;
    output [15:0] led;
    reg [15:0] led, led3_26, led1_23;
    reg [15:0] next_led3_26, next_led1_23;
    reg [15:0] led3_23, led1_26, next_led3_23, next_led1_26;

    wire clk_div23, clk_div26;
    clock_divider #(23) cd0(.clk(clk), .clk_div(clk_div23));
    clock_divider cd1(.clk(clk), .clk_div(clk_div26));

    always @(posedge clk_div23) begin
        if (rst == 1) begin
            led1_23 = {1'b1, 15'b0};
            led3_23 = {3'b111, 13'b0};
        end
        else begin
        if (en == 1) begin
            led1_23 = next_led1_23;
            led3_23 = next_led3_23;
        end
        else begin
            led1_23 = (dir == 1) ? led1_26 : led1_23;
            led3_23 = (dir == 1) ? led3_23 : led3_26;
        end
        end
    end

    always @(posedge clk_div26) begin
        if (rst == 1) begin
            led3_26 = {3'b111, 13'b0};
            led1_26 = {1'b1, 15'b0};
        end
        else begin
            if (en == 1) begin
                led3_26 = next_led3_26;
                led1_26 = next_led1_26;
            end
            else begin
                led3_26 = (dir == 1) ? led3_23 : led3_26;
                led1_26 = (dir == 1) ? led1_26 : led1_23;
            end
        end
    end

    always @(*) begin
        if (dir == 1) begin
            next_led1_23 = {led1_26[14:0], led1_26[15]};
            next_led3_26 = {led3_23[14:0], led3_23[15]};
            next_led1_26 = {led1_26[14:0], led1_26[15]};
            next_led3_23 = {led3_23[14:0], led3_23[15]};
        end
        else begin
            next_led1_23 = {led1_23[0], led1_23[15:1]};
            next_led3_26 = {led3_26[0], led3_26[15:1]};
            next_led1_26 = {led1_23[0], led1_23[15:1]};
            next_led3_23 = {led3_26[0], led3_26[15:1]};
        end
    end

    always @(posedge clk) begin
        if (rst == 1) begin
            led = {3'b111, 13'b0};
        end
        else begin
            if (en == 1) begin
                led = (dir == 1) ? led1_26 | led3_23 : led3_26 | led1_23;
            end
            else begin
                led = led;
            end
        end
    end
endmodule