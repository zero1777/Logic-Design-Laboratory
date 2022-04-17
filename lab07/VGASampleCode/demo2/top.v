`define shift_left 2'b00
`define shift_down 2'b01
`define init 2'b10
`define SPLIT 2'b11

module top(
   input clk,
   input rst,
   input shift,
   input split,
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output hsync,
   output vsync
    );

    wire [11:0] data;
    wire clk_25MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [8:0] pos;
    wire [1:0] state;

  assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel:12'h0;

     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );

    mem_addr_gen mem_addr_gen_inst(
    .clk(clk_22),
    .rst(rst),
    .split(split),
    .shift(shift),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .state(state),
    .pos(pos),
    .pixel_addr(pixel_addr)
    );
     
 
    blk_mem_gen_0 blk_mem_gen_0_inst(
      .clka(clk_25MHz),
      .wea(0),
      .addra(pixel_addr),
      .dina(data[11:0]),
      .douta(pixel)
    ); 

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(rst),
      .hsync(hsync),
      .vsync(vsync),
      .pos(pos),
      .valid(valid),
      .state(state),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
      
endmodule

/////////////////////////////////////////////////////////////////
// Module Name: vga
/////////////////////////////////////////////////////////////////

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
                    valid = ((pixel_cnt < HD) && (line_cnt < VD) && (pixel_cnt>>1 < 160-pos));
                else // right_down dir = down
                    valid = ((pixel_cnt < HD) && (line_cnt < VD) && (line_cnt>>1 > 120+pos));
            end
        endcase
    end

endmodule

module mem_addr_gen(
   input clk,
   input rst,
   input shift,
   input split,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output reg [1:0] state,
   output reg [8:0] pos,
   output reg [16:0] pixel_addr
   );
   reg [8:0] position, next_position; // h_cnt
   reg [8:0] position2, next_position2; // v_cnt
   reg [1:0] next_state;
   
   always @(*) begin
       case (state)
            `SPLIT : begin 
                if(h_cnt>>1 < 159 && v_cnt>>1 < 119) // left_up dir = up
                    pixel_addr = ((h_cnt>>1) + 320*(v_cnt>>1) + 320*position2) % 76800;
                else if(h_cnt>>1 > 159 && v_cnt>>1 < 119)  // right_up dir = right
                    pixel_addr = ((h_cnt>>1) + 320*(v_cnt>>1) - position) % 76800;
                else if(h_cnt>>1 < 159 && v_cnt>>1 > 119) //left_down dir = left
                    pixel_addr = ((h_cnt>>1) + 320*(v_cnt>>1) + position) % 76800;
                else // right_down dir = down
                    pixel_addr =  ((h_cnt>>1) + 320*(v_cnt>>1) - 320*position2) % 76800;
            end
            default begin
                pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1)) % 76800;
            end 
       endcase
   end

   always @(*) begin
       case (state) 
            `init : pos = position;
            `shift_left : pos = position;
            `shift_down : pos = position2;
            `SPLIT : begin
                if ((h_cnt>>1 > 159 && v_cnt>>1 < 119) ||
                    (h_cnt>>1 < 159 && v_cnt>>1 > 119)
                ) // pos = position
                    pos = position;
                else // pos = position2
                    pos = position2;
            end
       endcase
   end

   always @ (posedge clk or posedge rst) begin
      if(rst) begin
          position <= 0;
          position2 <= 0;
          state <= `init;
      end
      else begin
          position <= next_position;
          position2 <= next_position2;
          state <= next_state;
      end           
   end

   always @ (*) begin
       next_position = position;
       next_position2 = position2;
       next_state = state;
       case (state) 
           `init : begin
                next_position = 0;
                next_position2 = 0;
                if (shift) begin
                    next_state = `shift_left;
                end
                if (split) begin
                    next_state = `SPLIT;
                end
           end
           `shift_left : begin
                 if (position < 319) begin
                    next_position = position + 1;
                    next_state = `shift_left;
                end
                else begin
                    next_state = `shift_down;
                end    
           end
           `shift_down : begin
               if (position2 < 239) begin
                   next_position2 = position2 + 1;
                   next_state = `shift_down;
               end
               else begin
                   next_state = `init;
               end
           end 
           `SPLIT : begin
                next_state = state;
                if (position < 159) begin
                    next_position = position + 1;
                end
                if (position2 < 119) begin
                    next_position2 = position2 + 1;
                end
                if (position == 159 && position2 == 119) begin
                    next_state = `init;
                end
           end       
       endcase
       
   end
    
endmodule

