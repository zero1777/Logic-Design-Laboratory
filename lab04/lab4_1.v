module lab4_1 (SW, clk, reset, DIGIT, DISPLAY);
    input wire [15:0] SW;
    input wire clk;
    input wire reset;
    output wire [3:0] DIGIT;
    output wire [6:0] DISPLAY;

    wire clk_div13;
    reg [3:0] value;
    reg [3:0] digit;
    reg [6:0] display;
    wire [3:0] BCD0, BCD1, BCD2, BCD3;

    clock_divider #(13) cd0(.clk(clk), .clk_div(clk_div13));

    always @(posedge clk_div13) begin
        case (digit)
            4'b1110: begin
            value = (reset == 1) ? 4'd0 : BCD1;
            digit = 4'b1101;
            end
            4'b1101: begin
            value = (reset == 1) ? 4'd0 : BCD2;
            digit = 4'b1011;
            end
            4'b1011: begin
            value = (reset == 1) ? 4'd0 : BCD3;
            digit = 4'b0111;
            end
            4'b0111: begin
            value = (reset == 1) ? 4'd0 : BCD0;
            digit = 4'b1110;
            end
            default: begin
            value = (reset == 1) ? 4'd0 : BCD0;
            digit = 4'b1110;
            end
        endcase
    end

    always @* begin
        case (value)
            4'd0: display = 7'b1000000;
            4'd1: display = 7'b1111001;
            4'd2: display = 7'b0100100;
            4'd3: display = 7'b0110000;
            4'd4: display = 7'b0011001;
            4'd5: display = 7'b0010010;
            4'd6: display = 7'b0000010;
            4'd7: display = 7'b1111000;
            4'd8: display = 7'b0000000;
            4'd9: display = 7'b0010000;
            default: display = 7'b0010000;
        endcase
    end

    assign BCD0 = SW[3:0];
    assign BCD1 = SW[7:4];
    assign BCD2 = SW[11:8];
    assign BCD3 = SW[15:12];
    assign DIGIT = digit;
    assign DISPLAY = display;

endmodule