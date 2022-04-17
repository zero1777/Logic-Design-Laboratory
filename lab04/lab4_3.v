module lab4_3 (
    input wire en,
    input wire reset,
    input wire clk,
    input wire mode,
    input wire min_plus,
    input wire sec_plus,
    output wire [3:0] DIGIT,
    output wire [6:0] DISPLAY,
    output wire stop
    );

    reg [3:0] digit;
    reg [6:0] display;
    reg [6:0] second, minute;
    wire [6:0] sec1, sec2, min1, min2;
    reg enable;
    reg [6:0] value;

    wire clk_div13, clk_div16, clk_div, clk_div25, clk_div26, clk_1sec, clk_div20;
    wire min_plus_debounced, sec_plus_debounced, en_debounced;
    wire min_plus_1pulse, sec_plus_1pulse, en_1pulse, mode_1pulse;

    clock_divider #(13) cd0 (.clk(clk), .clk_div(clk_div13));
    clock_divider #(16) cd1 (.clk(clk), .clk_div(clk_div16));
    clock_divider #(25) cd2 (.clk(clk), .clk_div(clk_div25));
    clock_divider #(26) cd3 (.clk(clk), .clk_div(clk_div26));
    clock_divider #(20) cd4 (.clk(clk), .clk_div(clk_div20));
    clock_divider_1HZ cd5 (.clk(clk), .clk_div(clk_1sec));

    debounce de0 (.pb_debounced(min_plus_debounced), .pb(min_plus), .clk(clk_div16));
    debounce de1 (.pb_debounced(sec_plus_debounced), .pb(sec_plus), .clk(clk_div16));
    debounce de2 (.pb_debounced(en_debounced), .pb(en), .clk(clk_div16));
    
    onepulse op0 (.pb_debounced(min_plus_debounced), .clk(clk_div16), .pb_1pulse(min_plus_1pulse));
    onepulse op1 (.pb_debounced(sec_plus_debounced), .clk(clk_div16), .pb_1pulse(sec_plus_1pulse));
    onepulse op2 (.pb_debounced(en_debounced), .clk(clk_div16), .pb_1pulse(en_1pulse));
    onepulse_neg op3 (.pb_debounced(mode), .clk(clk_div16), .pb_1pulse(mode_1pulse));

    always @(posedge clk_div16) begin
        if (reset == 1) begin
            enable = 1'b0;
        end
        else begin
            if (mode == 0) begin
                enable = 1'b0;
            end
            else begin
                enable = (en_1pulse == 1) ? ~enable : enable;
            end
        end
    end

    always @(posedge clk_div or posedge reset) begin
        if (reset == 1) begin
            second = 7'b0;
            minute = 7'b0;
        end
        else begin
            if (mode == 0) begin
                if (mode_1pulse == 0) begin
                    minute = 7'd0;
                    second = 7'd0;
                end
                else if (min_plus_1pulse == 1) begin
                    minute = (minute == 7'd59) ? 7'd0 : minute + 1;
                    second = second;
                end
                else if (sec_plus_1pulse == 1) begin
                    if (second == 7'd59) begin
                        if (minute == 7'd59) begin
                            minute = 7'd0;
                            second = 7'd0;
                        end
                        else begin
                            minute = minute + 1;
                            second = 7'd0;
                        end
                    end
                    else begin
                        minute = minute;
                        second = second + 1;
                    end
                end
                else begin
                    minute = minute;
                    second = second;
                end
            end
            else begin
                if (enable == 1) begin
                    if (second == 7'd0) begin
                        if (minute == 7'd0) begin
                            minute = 7'd0;
                            second = 7'd0;
                        end
                        else begin
                            minute = minute - 1;
                            second = 7'd59;
                        end
                    end
                    else begin
                        minute = minute;
                        second = second - 1;
                    end
                end
                else begin
                    minute = minute;
                    second = second;
                end
            end
        end
    end

    always @(posedge clk_div13) begin
        case (digit)
            4'b1110: begin
                value = sec1;
                digit = 4'b1101;
            end
            4'b1101: begin
                value = min2;
                digit = 4'b1011;
            end
            4'b1011: begin
                value = min1;
                digit = 4'b0111;
            end
            4'b0111: begin
                value = sec2;
                digit = 4'b1110;
            end
            default: begin
                value = sec2;
                digit = 4'b1110;
            end
        endcase
    end

    always @* begin
        case (value)
            7'd0: display = 7'b1000000;
            7'd1: display = 7'b1111001;
            7'd2: display = 7'b0100100;
            7'd3: display = 7'b0110000;
            7'd4: display = 7'b0011001;
            7'd5: display = 7'b0010010;
            7'd6: display = 7'b0000010;
            7'd7: display = 7'b1111000;
            7'd8: display = 7'b0000000;
            7'd9: display = 7'b0010000;
            default: display = 7'b0010000;
        endcase
    end

    assign sec1 = second / 7'd10;
    assign sec2 = second % 7'd10;
    assign min1 = minute / 7'd10;
    assign min2 = minute % 7'd10;
    assign DIGIT = digit;
    assign DISPLAY = display;
    assign clk_div = (mode == 0) ? clk_div16 : clk_1sec;
    assign stop = (minute == 7'd0 && second == 7'd0 && mode == 1'b1) ? 1'b1 : 1'b0;

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

module onepulse (pb_debounced, clk, pb_1pulse);
    input pb_debounced;
    input clk;
    output pb_1pulse;
    reg pb_1pulse;
    reg pb_debounced_delay;
    always @(posedge clk) begin
        if (pb_debounced == 1'b1 & pb_debounced_delay == 1'b0)
            pb_1pulse <= 1'b1;
        else
            pb_1pulse <= 1'b0;
        pb_debounced_delay <= pb_debounced;
    end
endmodule

module onepulse_neg (pb_debounced, clk, pb_1pulse);
    input pb_debounced;
    input clk;
    output pb_1pulse;
    reg pb_1pulse;
    reg pb_debounced_delay;
    always @(posedge clk) begin
        if (pb_debounced == 1'b0 & pb_debounced_delay == 1'b0)
            pb_1pulse <= 1'b0;
        else
            pb_1pulse <= 1'b1;
        pb_debounced_delay <= ~pb_debounced;
    end
endmodule

module clock_divider_1sec(clk, clk_div);
    parameter n = 7;
    input clk;
    output clk_div;

    reg [n-1:0] num;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num = next_num;
    end

    assign next_num = (num == 7'd99) ? 7'd0 : num + 7'd1;
    assign clk_div = (num > 7'd49) ? 1'b1 : 1'b0;
endmodule

module clock_divider_1HZ(clk, clk_div);
    parameter n = 27;
    
    input clk;
    output clk_div;
    reg [n-1:0]cnt;
    reg clk_div;
    wire dir;
    always@(posedge clk) begin
        if(cnt == 49999999) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end 
        else begin
            cnt <= cnt + 1;
            clk_div <= clk_div;
        end
    end
endmodule