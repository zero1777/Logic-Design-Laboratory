`define shift_left 2'b00
`define shift_down 2'b01
`define init 2'b10
`define SPLIT 2'b11
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
