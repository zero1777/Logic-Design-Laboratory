module top(
   input clk,
   input rst,
   input shift,
   input Split,
   output [3:0] vgaRed,
   output [3:0] vgaGreen,
   output [3:0] vgaBlue,
   output hsync,
   output vsync
   );

    wire [11:0] data;
    wire clk_25MHz;
    wire clk_50MHz;
    wire clk_22;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid, stop,stop2;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
    wire [8:0] position;
    wire [8:0] position2;
    reg split_valid,shift_valid,down_valid;
    wire shift_d,split_d,shift_b,split_b;
    
    reg [2:0] state,next_state;
    parameter IDLE = 3'd0;
    parameter LEFT = 3'd1;
    parameter DOWN = 3'd2;
    parameter SPLIT = 3'd3;
  assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? pixel:12'h0;
  
  always@(posedge clk or posedge rst) begin
        if(rst)begin
            state = IDLE;
        end else
            state = next_state;        
  end
  always@(*)begin
    case(state)
        IDLE:begin
            next_state = (shift_b)?LEFT:(split_b)?SPLIT:state;
        end
        LEFT:begin
            next_state =(shift_valid==0) ?DOWN:state;
        end
        DOWN:begin
            next_state = (down_valid==0)?IDLE:state;
        end
        SPLIT:begin
            next_state =(split_valid==0) ?IDLE:state;
        end   
    endcase
  end
    always@(*)begin
    case(state)
        IDLE:begin
        
        end
        LEFT:begin
        
        end
        DOWN:begin
        
        end
        SPLIT:begin
        
        end   
    endcase
  end
    always@(*)begin
    case(state)
        IDLE:begin
        
        end
        LEFT:begin
        
        end
        DOWN:begin
        
        end
        SPLIT:begin
        
        end   
    endcase
  end
  always@(posedge clk or posedge rst) begin
       if(rst)begin
            split_valid <= 0;
            shift_valid <=0;
            down_valid <=0;
       end
       else if(shift_b) shift_valid <= 1;
       else if(split_b) split_valid <= 1;
       else if(stop) begin
            split_valid <= 0;
            shift_valid <= 0;
            down_valid <=1;
       end
       else if(stop2)begin
            split_valid <= 0;
            shift_valid <= 0;
            down_valid<=0;
       end
       else begin
            split_valid <= split_valid;
            shift_valid <= shift_valid;
            down_valid <= down_valid;
       end
  end

     clock_divisor clk_wiz_0_inst(
      .clk(clk),
      .clk1(clk_25MHz),
      .clk22(clk_22)
    );

    mem_addr_gen mem_addr_gen_inst(
    .clk(clk_22),
    .rst(rst),
    .split(split_valid),.shift(shift_valid),.down(down_valid),
    .h_cnt(h_cnt),
    .v_cnt(v_cnt),
    .position(position),
    .position2(position2),
    .pixel_addr(pixel_addr),
    .stop(stop),
    .stop2(stop2)
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
      .split(split_valid),.shift(shift_valid),.down(down_valid),
      .position(position),
      .position2(position2),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
    OnePulse o1(
        .signal_single_pulse(shift_b),
        .signal(shift_d),
        .clock(clk)
        );
    OnePulse o2(
        .signal_single_pulse(split_b),
        .signal(split_d),
        .clock(clk)
        );
    debounce d1(.pb_debounced(shift_d), .pb(shift), .clk(clk));
    debounce d2(.pb_debounced(split_d), .pb(Split), .clk(clk));

endmodule
    
module vga_controller (
    input wire pclk, clk22, reset, split,shift,down,
    input wire [8:0]position,
    input wire [8:0]position2,
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
    // ---------------------------------------------
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
    
/*
----------------------------------------------
             1     ^        |            2      ->
----------------------------------------------
       <-     3             |             4         v
----------------------------------------------
*/
    always @(*) begin
        valid = ((pixel_cnt < HD) && (line_cnt < VD));
        if(shift) valid = ((pixel_cnt < HD) && (line_cnt < VD)&& (pixel_cnt>>1 >=239- position));
        else if(down)begin
            valid =((pixel_cnt < HD) && (line_cnt < VD)&& (pixel_cnt>>1 < 319- position));
        end
        else if(split) begin
            if(line_cnt>>1 < 119&&pixel_cnt>>1<159) valid = ((pixel_cnt < HD) && (line_cnt < VD)&& (line_cnt>>1 < 119-position2));//左上
            else if(line_cnt>>1 < 119&&pixel_cnt>>1>159) valid = ((pixel_cnt < HD) && (line_cnt < VD)&& (pixel_cnt>>1 >160+position));//右上
            else if(line_cnt>>1 > 119&&pixel_cnt>>1<159) valid = ((pixel_cnt < HD) && (line_cnt < VD)&& (pixel_cnt>>1 < 159-position));//左下
            else valid = ((pixel_cnt < HD) && (line_cnt < VD)&& (line_cnt>>1 > 119+position));//右下
        end 
        
    end
    
    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt : 10'd0;
    assign v_cnt = (line_cnt < VD) ? line_cnt : 10'd0;

endmodule

module mem_addr_gen(
   input clk,
   input rst,
   input split,shift,down,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output reg [8:0] position,
   output reg [8:0] position2,
   output reg [16:0] pixel_addr,
   output stop,
   output stop2
   );
   
   reg [5:0] cnt;

 /*
----------------------------------------------
             1     ^        |            2      ->
----------------------------------------------
       <-     3             |             4         v
----------------------------------------------
*/                                       
   always@(*) begin
         pixel_addr = (((h_cnt>>1) )%320 + 320*(v_cnt>>1))%76800;
        if (shift) begin
             pixel_addr = (((h_cnt>>1))%320 + 320*(v_cnt>>1))%76800;
        end
        else if(down)begin0
             pixel_addr = (((h_cnt>>1) )%320 + 320*(v_cnt>>1))%76800;
        end
        else if (split) begin

            if(v_cnt>>1 < 119&&h_cnt>>1<159) pixel_addr = (((h_cnt>>1))%320 + 320*(v_cnt>>1)+320*position2)%76800;//左上
            else if(v_cnt>>1 < 119&&h_cnt>>1>159) pixel_addr = (((h_cnt>>1) - position)%320 + 320*(v_cnt>>1))%76800;//右上
            else if(v_cnt>>1 > 119&&h_cnt>>1<159) pixel_addr = (((h_cnt>>1) +  position)%320 + 320*(v_cnt>>1))%76800;//左下
            else pixel_addr =  (((h_cnt>>1))%320 + 320*(v_cnt>>1)-320*position)%76800;//右下
        end
   end
   
                                        
   assign stop = cnt[5];
   assign stop2 = cnt[5];
   always @ (posedge clk or posedge rst) begin
      if(rst) begin
          position2 <= 0;
          position <= 0;
          cnt <= 0;
      end
      else if(shift) begin
           if(position < 319) begin
               position <= position + 1;
               cnt <= cnt;
           end
           else begin
               position <= position;
               cnt <= cnt + 1'b1;
           end
      end
      else if(down) begin
           if(position < 239) begin
               position <= position + 1;
               cnt <= cnt;
           end
           else begin
               position <= position;
               cnt <= cnt + 1'b1;
           end
      end
      else if(split) begin
         if(position2 < 119) begin
             position2 <= position2 + 1;
             cnt <= cnt;
             
         end
         else begin
             position2 <= position2;
             cnt <= cnt + 1'b1;
             
         end
         if(position < 159) begin
             position <= position + 1;
             cnt <= cnt;
         end
         else begin
             position <= position;
             cnt <= cnt + 1'b1;
         end
      end
      else begin
          position <= 0;
          position2 <= 0;
          cnt <= 0;
      end
   end
    
endmodule
module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
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