module mem_addr_gen(
   input clk,
   input rst,
   input en,
   input dir,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   output [16:0] pixel_addr
   );
    
   reg [8:0] position;
  
   assign pixel_addr = ((h_cnt>>1)+320*(v_cnt>>1)+ position)% 76800;  //640*480 --> 320*240 

   always @ (posedge clk or posedge rst) begin
      if(rst) begin
          position <= 0;
      end
      else begin
          if (en) begin
              if (dir == 0) begin
                  if (position < 319) position <= position + 1;
                  else position <= 0;
              end
              else begin
                  if (position > 0) position <= position - 1;
                  else position <= 319;
              end
          end
          else begin
              position <= position;
          end
      end
          
       else if(position < 319)
           
       else
           position <= 0;
   end
    
endmodule
