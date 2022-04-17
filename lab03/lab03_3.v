module lab03_3(clk, rst, en, led);
    input clk;
    input rst;
    input en;
    output [15:0] led;

    reg [15:0] led;
    reg [15:0] led3, next_led3;
    reg [15:0] led3_middle, next_led3_middle;
    reg [15:0] led1, next_led1;
    reg dir;
  

    wire clk_div23, clk_div26;
    clock_divider #(23) cd0(.clk(clk), .clk_div(clk_div23));
    clock_divider cd1(.clk(clk), .clk_div(clk_div26));

    always @(posedge clk_div23) begin
        if (rst == 1) begin
            led1 = {1'b1, 15'b0};
            dir = 1'b1;
        end
        else begin
            if (en == 1) begin
                if ((led1 & led3) != 16'd0) begin
                    if ((led1 & led3_middle) != 16'd0) begin
                        if (dir == 1) begin
                            led1 = {led1[13:0], led1[15:14]};
                            dir = ~dir;
                        end
                        else begin
                            led1 = {led1[1:0], led1[15:2]};
                            dir = ~dir;
                        end
                    end
                    else begin
                         if (dir == 1) begin
                            led1 = {led1[14:0], led1[15]};
                            dir = ~dir;
                        end
                        else begin
                            led1 = {led1[0], led1[15:1]};
                            dir = ~dir;
                        end
                    end
                end
                else begin
                    dir = dir;
                    led1 = next_led1;
                end
            end
            else begin+
                led1 = led1;
                dir = dir;
            end
        end
    end

    always @(posedge clk_div26) begin
        if (rst == 1) begin
            led3 = {3'b111, 13'b0};
            led3_middle = {2'b01, 14'b0};
        end
        else begin
            if (en == 1) begin
                led3 = next_led3;
                led3_middle = next_led3_middle;
            end
            else begin
                led3 = led3;
                led3_middle = led3_middle;
            end
        end
    end

    always @(*) begin
        next_led3 = {led3[0], led3[15:1]};
        next_led3_middle = {led3_middle[0], led3_middle[15:1]};
        if (dir == 1) begin
            next_led1 = {led1[0], led1[15:1]};
        end
        else begin
            next_led1 = {led1[14:0], led1[15]};
        end
    end

    always @(posedge clk) begin
        if (rst == 1) begin
            led = {3'b111, 13'b0};
        end
        else begin
            if (en == 1) begin
                led = led1 | led3;
            end
            else begin
                led = led;
            end
        end
    end 
endmodule