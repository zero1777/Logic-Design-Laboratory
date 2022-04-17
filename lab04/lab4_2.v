module lab4_2 (en, reset, clk, dir, record, DIGIT, DISPLAY, max, min);
    input en;
    input reset;
    input clk;
    input dir;
    input record;
    output reg [3:0] DIGIT;
    output reg [6:0] DISPLAY;
    output max;
    output min;

    wire clk_div23, clk_div25, clk_div13, clk_div16;
    wire en_debounced, dir_debounced, rec_debounced, rst_debounced;
    reg direction, enable;
    wire direc, ena, rec, rst;
    
    reg [3:0] value;
    reg [3:0] digit1, digit2;
    reg [3:0] next_digit1, next_digit2;
    reg [3:0] rdigit1, rdigit2;
    reg [3:0] next_rdigit1, next_rdigit2;

    clock_divider #(23) cd0 (.clk(clk), .clk_div(clk_div23));
    clock_divider #(25) cd1 (.clk(clk), .clk_div(clk_div25));
    clock_divider #(13) cd2 (.clk(clk), .clk_div(clk_div13));
    clock_divider #(16) cd3 (.clk(clk), .clk_div(clk_div16));

    debounce de0 (.pb_debounced(en_debounced), .pb(en), .clk(clk_div16));
    debounce de1 (.pb_debounced(dir_debounced), .pb(dir), .clk(clk_div16));
    debounce de2 (.pb_debounced(rec_debounced), .pb(record), .clk(clk_div16));
    debounce de3 (.pb_debounced(rst_debounced), .pb(reset), .clk(clk_div16));

    onepulse op0 (.pb_debounced(rst_debounced), .clk(clk_div16), .pb_1pulse(rst));
    onepulse op1 (.pb_debounced(dir_debounced), .clk(clk_div16), .pb_1pulse(direc));
    onepulse op2 (.pb_debounced(en_debounced), .clk(clk_div16), .pb_1pulse(ena));
    onepulse op3 (.pb_debounced(rec_debounced), .clk(clk_div16), .pb_1pulse(rec));

    always@(posedge clk_div23) begin
        if (reset == 1) begin
            digit1 = 4'b0000;
            digit2 = 4'b0000;
        end
        else begin
            if (enable == 1) begin
                digit1 = next_digit1;
                digit2 = next_digit2;
            end
            else begin
                digit1 = digit1;
                digit2 = digit2;
            end
        end
    end

    always @(posedge clk_div16) begin
        if (reset == 1) begin
            rdigit1 = 4'b0000;
            rdigit2 = 4'b0000;
        end
        else begin
            if (rec == 1) begin
                rdigit1 = digit1;
                rdigit2 = digit2;
            end
            else begin
                rdigit1 = rdigit1;
                rdigit2 = rdigit2;
            end
        end
    end

    always @(posedge clk_div13) begin
        case (DIGIT)
            4'b1110: begin
            value = digit1;
            DIGIT = 4'b1101;
            end
            4'b1101: begin
            value = rdigit2;
            DIGIT = 4'b1011;
            end
            4'b1011: begin
            value = rdigit1;
            DIGIT = 4'b0111;
            end
            4'b0111: begin
            value = digit2;
            DIGIT = 4'b1110;
            end
            default: begin
            value = digit2;
            DIGIT = 4'b1110;
            end
        endcase
    end

    always @(posedge clk_div16) begin
        if (reset == 1) begin
            direction = 1'b1;
            enable = 1'b0;
        end
        else begin
            direction = (direc == 1) ? ~direction : direction;
            enable = (ena == 1) ? ~enable : enable;
        end
    end

    always @* begin
        case (value)
            4'd0: DISPLAY = 7'b1000000;
            4'd1: DISPLAY = 7'b1111001;
            4'd2: DISPLAY = 7'b0100100;
            4'd3: DISPLAY = 7'b0110000;
            4'd4: DISPLAY = 7'b0011001;
            4'd5: DISPLAY = 7'b0010010;
            4'd6: DISPLAY = 7'b0000010;
            4'd7: DISPLAY = 7'b1111000;
            4'd8: DISPLAY = 7'b0000000;
            4'd9: DISPLAY = 7'b0010000;
            default: DISPLAY = 7'b0010000;
        endcase
    end

    always @(posedge clk_div25) begin
        if (direction == 1) begin
            next_digit1 = (digit2 == 4'd9 && digit1 != 4'd9) ? digit1 + 1 : digit1;
            next_digit2 = (digit2 == 4'd9) ? ((digit1 == 4'd9) ? digit2 : 4'b0000) : digit2 + 1;
        end
        else begin
            next_digit1 = (digit2 == 4'd0 && digit1 != 4'd0) ? digit1 - 1 : digit1;
            next_digit2 = (digit2 == 4'd0) ? ((digit1 == 4'd0) ? digit2 : 4'd9) : digit2 - 1;
        end
    end

    assign max = (digit1 == 4'd9 && digit2 == 4'd9 && direction == 1) ? 1'b1 : 1'b0;
    assign min = (digit1 == 4'd0 && digit2 == 4'd0 && direction == 0) ? 1'b1 : 1'b0;

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