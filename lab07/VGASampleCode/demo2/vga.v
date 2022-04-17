`timescale 1ns/1ps
/////////////////////////////////////////////////////////////////
// Module Name: vga
/////////////////////////////////////////////////////////////////
`define shift_left 2'b00
`define shift_down 2'b01
`define init 2'b10
`define SPLIT 2'b11
module vga_controller (
    input wire pclk, reset,
    input wire [8:0]pos,
    input wire [1:0]state,
    output wire hsync, vsync, 
    output reg valid,
    output wire [9:0]h_cnt,
    output wire [9:0]v_cnt
    );

    reg [9:0]pixel_cnt;
    reg [9:0]line_cnt;
    reg hsync_i,vsync_i;

    parameter HD = 640;
    parameter HF = 16;
    parameter HS = 96;
    parameter HB = 48;
    parameter HT = 800; 
    parameter VD = 480;
    parameter VF = 10;
    parameter VS = 2;
    parameter VB = 33;
    parameter VT = 525;
    parameter hsync_default = 1'b1;
    parameter vsync_default = 1'b1;

    always @(posedge pclk)
        if (reset)
            pixel_cnt <= 0;
        else
            if (pixel_cnt < (HT - 1))
                pixel_cnt <= pixel_cnt + 1;
            else
                pixel_cnt <= 0;

    always @(posedge pclk)
        if (reset)
            hsync_i <= hsync_default;
        else
            if ((pixel_cnt >= (HD + HF - 1)) && (pixel_cnt < (HD + HF + HS - 1)))
                hsync_i <= ~hsync_default;
            else
                hsync_i <= hsync_default; 

    always @(posedge pclk)
        if (reset)
            line_cnt <= 0;
        else
            if (pixel_cnt == (HT -1))
                if (line_cnt < (VT - 1))
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;

    always @(posedge pclk)
        if (reset)
            vsync_i <= vsync_default; 
        else if ((line_cnt >= (VD + VF - 1)) && (line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default; 
        else
            vsync_i <= vsync_default; 

    assign hsync = hsync_i;
    assign vsync = vsync_i;

    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt : 10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt : 10'd0;

    always @(*) begin
        case (state)
            `init : begin
                valid = ((pixel_cnt < HD) && (line_cnt < VD));
            end
            `shift_left : begin
                valid = ((pixel_cnt < HD) && (line_cnt < VD) && (pixel_cnt >> 1 < 319-pos));
            end
            `shift_down : begin
                valid = ((pixel_cnt < HD) && (line_cnt < VD) && (line_cnt >> 1 < pos));
            end
            `SPLIT : begin
                valid = ((pixel_cnt < HD) && (line_cnt < VD)); 
                if(pixel_cnt>>1 < 159 && line_cnt>>1 < 119) // left_up dir = up
                    valid = ((pixel_cnt < HD) && (line_cnt < VD) && (line_cnt>>1 < 119-pos));
                else if(pixel_cnt>>1 > 159 && line_cnt>>1 < 119) // right_up dir = right
                    valid = ((pixel_cnt < HD) && (line_cnt < VD) && (pixel_cnt>>1 > 159+pos));
                else if(pixel_cnt>>1 < 159 && line_cnt>>1 > 119) //left_down dir = left
                    valid = ((pixel_cnt < HD) && (line_cnt < VD) && (pixel_cnt>>1 < 159-pos));
                else // right_down dir = down
                    valid = ((pixel_cnt < HD) && (line_cnt < VD) && (line_cnt>>1 > 119+pos));
            end
        endcase
    end

endmodule
