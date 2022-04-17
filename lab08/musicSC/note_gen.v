module note_gen(
    clk, // clock from crystal
    rst, // active high reset
    note_div_left, // div for note generation
    note_div_right,
    audio_left,
    audio_right,
    volume
);

    // I/O declaration
    input clk; // clock from crystal
    input rst; // active low reset
    input [21:0] note_div_left, note_div_right; // div for note generation
    output reg [15:0] audio_left, audio_right;
    input [2:0] volume;

    // Declare internal signals
    reg [21:0] clk_cnt_next, clk_cnt;
    reg [21:0] clk_cnt_next_2, clk_cnt_2;
    reg b_clk, b_clk_next;
    reg c_clk, c_clk_next;

    // Note frequency generation
    always @(posedge clk or posedge rst)
        if (rst == 1'b1)
            begin
                clk_cnt <= 22'd0;
                clk_cnt_2 <= 22'd0;
                b_clk <= 1'b0;
                c_clk <= 1'b0;
            end
        else
            begin
                clk_cnt <= clk_cnt_next;
                clk_cnt_2 <= clk_cnt_next_2;
                b_clk <= b_clk_next;
                c_clk <= c_clk_next;
            end
        
    always @*
        if (clk_cnt == note_div_left)
            begin
                clk_cnt_next = 22'd0;
                b_clk_next = ~b_clk;
            end
        else
            begin
                clk_cnt_next = clk_cnt + 1'b1;
                b_clk_next = b_clk;
            end

    always @*
        if (clk_cnt_2 == note_div_right)
            begin
                clk_cnt_next_2 = 22'd0;
                c_clk_next = ~c_clk;
            end
        else
            begin
                clk_cnt_next_2 = clk_cnt_2 + 1'b1;
                c_clk_next = c_clk;
            end

    // Assign the amplitude of the note
    // Volume is controlled here
    // assign audio_left = (note_div_left == 22'd1) ? 16'h0000 : (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
    // assign audio_right = (note_div_right == 22'd1) ? 16'h0000 : (c_clk == 1'b0) ? 16'hE000 : 16'h2000;

    always @(*) begin
        case (volume)
            3'd0 : begin
                audio_left = 16'h0000;
                audio_right = 16'h0000;
            end
            3'd1: begin
                audio_left = (b_clk == 1'b0) ? 16'hF000 : 16'h1000;
                audio_right = (c_clk == 1'b0) ? 16'hF000 : 16'h1000;
            end
            3'd2 : begin
                audio_left = (b_clk == 1'b0) ? 16'hE000 : 16'h2000;
                audio_right = (c_clk == 1'b0) ? 16'hE000 : 16'h2000;
            end
            3'd3 : begin
                audio_left = (b_clk == 1'b0) ? 16'hB000 : 16'h4000;
                audio_right = (c_clk == 1'b0) ? 16'hB000 : 16'h4000;
            end
            3'd4 : begin
                audio_left = (b_clk == 1'b0) ? 16'hA000 : 16'h6000;
                audio_right = (c_clk == 1'b0) ? 16'hA000 : 16'h6000;
            end
            3'd5 : begin
                audio_left = (b_clk == 1'b0) ? 16'h9000 : 16'h7000;
                audio_right = (c_clk == 1'b0) ? 16'h9000 : 16'h7000;
            end
            default : begin
                audio_left = 16'h0000;
                audio_right = 16'h0000;
            end
        endcase
    end 

endmodule