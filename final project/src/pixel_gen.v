`define WAIT 3'b000
`define PAY 3'b001
`define SEND_PROCESS 3'b010

`define LEFT 2'b00
`define MIDDLE 2'b01
`define RIGHT 2'b10

module pixel_gen(
   input clk,
   input bclk,
   input rst,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   input valid,
   input [1:0] pos,
   input [11:0] pixel,
   input [2:0] state,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue
   );
   
     reg [9:0] block_v, block_h, next_block_h, next_block_v;
     reg [9:0] block_v2, block_h2, next_block_h2, next_block_v2;
     reg [9:0] block_v3, block_h3, next_block_h3, next_block_v3;
     reg [9:0] block_v4, block_h4, next_block_h4, next_block_v4;
     reg [9:0] block_v5, block_h5, next_block_h5, next_block_v5;
     reg [9:0] block_v6, block_h6, next_block_h6, next_block_v6;
     reg [9:0] block_v7, block_h7, next_block_h7, next_block_v7;
     reg [9:0] block_v8, block_h8, next_block_h8, next_block_v8;
     reg [9:0] block_v9, block_h9, next_block_h9, next_block_v9;
     reg [9:0] block_v10, block_h10, next_block_h10, next_block_v10;
     reg [9:0] block_v11, block_h11, next_block_h11, next_block_v11;
     reg [9:0] block_v12, block_h12, next_block_h12, next_block_v12;
     reg [9:0] block_v13, block_h13, next_block_h13, next_block_v13;
     reg [9:0] block_v14, block_h14, next_block_h14, next_block_v14;
     reg [9:0] block_v15, block_h15, next_block_h15, next_block_v15;
     reg [9:0] block_v16, block_h16, next_block_h16, next_block_v16;
     reg [9:0] block_v17, block_h17, next_block_h17, next_block_v17;
     reg [9:0] block_v18, block_h18, next_block_h18, next_block_v18;
     reg [9:0] block_v19, block_h19, next_block_h19, next_block_v19;
     reg [9:0] block_v20, block_h20, next_block_h20, next_block_v20;

     always @(posedge bclk, posedge rst) begin
          if (rst) begin
               block_h = 10'd129;    block_v = 10'd50;
               block_h2 = 10'd129;   block_v2 = 10'd50;
               block_h3 = 10'd129;   block_v3 = 10'd50;
               block_h4 = 10'd129;   block_v4 = 10'd50;
               block_h5 = 10'd129;   block_v5 = 10'd50;
               block_h6 = 10'd129;    block_v6 = 10'd50;
               block_h7 = 10'd129;   block_v7 = 10'd50;
               block_h8 = 10'd129;   block_v8 = 10'd50;
               block_h9 = 10'd129;   block_v9 = 10'd50;
               block_h10 = 10'd129;   block_v10 = 10'd50;
               block_h11 = 10'd129;    block_v11 = 10'd50;
               block_h12 = 10'd129;   block_v12 = 10'd50;
               block_h13 = 10'd129;   block_v13 = 10'd50;
               block_h14 = 10'd129;   block_v14 = 10'd50;
               block_h15 = 10'd129;   block_v15 = 10'd50;
               block_h16 = 10'd129;    block_v16 = 10'd50;
               block_h17 = 10'd129;   block_v17 = 10'd50;
               block_h18 = 10'd129;   block_v18 = 10'd50;
               block_h19 = 10'd129;   block_v19 = 10'd50;
               block_h20 = 10'd129;   block_v20 = 10'd50;
               
          end
          else begin
               block_h = next_block_h;     block_v = next_block_v;
               block_h2 = next_block_h2;   block_v2 = next_block_v2;
               block_h3 = next_block_h3;   block_v3 = next_block_v3;
               block_h4 = next_block_h4;   block_v4 = next_block_v4;
               block_h5 = next_block_h5;   block_v5 = next_block_v5;
               block_h6 = next_block_h6;     block_v6 = next_block_v6;
               block_h7 = next_block_h7;   block_v7 = next_block_v7;
               block_h8 = next_block_h8;   block_v8 = next_block_v8;
               block_h9 = next_block_h9;   block_v9 = next_block_v9;
               block_h10 = next_block_h10;   block_v10 = next_block_v10;
               block_h11 = next_block_h11;     block_v11 = next_block_v11;
               block_h12 = next_block_h12;   block_v12 = next_block_v12;
               block_h13 = next_block_h13;   block_v13 = next_block_v13;
               block_h14 = next_block_h14;   block_v14 = next_block_v14;
               block_h15 = next_block_h15;   block_v15 = next_block_v15;
               block_h16 = next_block_h16;     block_v16 = next_block_v16;
               block_h17 = next_block_h17;   block_v17 = next_block_v17;
               block_h18 = next_block_h18;   block_v18 = next_block_v18;
               block_h19 = next_block_h19;   block_v19 = next_block_v19;
               block_h20 = next_block_h20;   block_v20 = next_block_v20;
          end
     end

     always @(*) begin
          next_block_h = block_h;   next_block_v = block_v;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h == 10'd129 && block_v == 10'd50) begin
                                   next_block_h = 10'd30;
                                   next_block_v = 10'd50;
                              end
                              else if (block_h >= 10'd30 && block_h < 10'd90 && block_v == 10'd50) begin
                                   next_block_h = block_h + 10'd1;
                              end
                              else if (block_h > 10'd30 && block_h <= 10'd90 && block_v == 10'd150) begin
                                   next_block_h = block_h - 10'd1;
                              end
                              else if (block_v >= 10'd50 && block_v < 10'd150 && block_h == 10'd90) begin
                                   next_block_v = block_v + 10'd1;
                              end
                              else if (block_v > 10'd50 && block_v <= 10'd150 && block_h == 10'd30) begin
                                   next_block_v = block_v - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h == 10'd129 && block_v == 10'd50) begin
                                   next_block_h = 10'd130;
                                   next_block_v = 10'd50;
                              end
                              else if (block_h >= 10'd130 && block_h < 10'd190 && block_v == 10'd50) begin
                                   next_block_h = block_h + 10'd1;
                              end
                              else if (block_h > 10'd130 && block_h <= 10'd190 && block_v == 10'd150) begin
                                   next_block_h = block_h - 10'd1;
                              end
                              else if (block_v >= 10'd50 && block_v < 10'd150 && block_h == 10'd190) begin
                                   next_block_v = block_v + 10'd1;
                              end
                              else if (block_v > 10'd50 && block_v <= 10'd150 && block_h == 10'd130) begin
                                   next_block_v = block_v - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h == 10'd129 && block_v == 10'd50) begin
                                   next_block_h = 10'd230;
                                   next_block_v = 10'd50;
                              end
                              else if (block_h >= 10'd230 && block_h < 10'd290 && block_v == 10'd50) begin
                                   next_block_h = block_h + 10'd1;
                              end
                              else if (block_h > 10'd230 && block_h <= 10'd290 && block_v == 10'd150) begin
                                   next_block_h = block_h - 10'd1;
                              end
                              else if (block_v >= 10'd50 && block_v < 10'd150 && block_h == 10'd290) begin
                                   next_block_v = block_v + 10'd1;
                              end
                              else if (block_v > 10'd50 && block_v <= 10'd150 && block_h == 10'd230) begin
                                   next_block_v = block_v - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h = 10'd129;
                    next_block_v = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          case (state)
               `WAIT : begin
                    if (valid) begin
                         case (pos)
                              `LEFT : begin
                                   if ((h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 30) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 90)
                                        )
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   else if (h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end 
                              `MIDDLE : begin
                                   if ((h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 130) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 190)
                                        )
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   else if (h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end
                              `RIGHT : begin
                                   if ((h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 230) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 290)
                                        )
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   else if (h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end
                              default: 
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                         endcase
                    end
                    else 
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
               end
               `PAY : begin
                    if (valid) begin
                         case (pos)
                              `LEFT : begin
                                   if ((h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 30) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 90)
                                   ) begin
                                        if ((h_cnt >> 1 == block_h && v_cnt >> 1 == block_v) ||
                                        (h_cnt >> 1 == block_h2 && v_cnt >> 1 == block_v2) ||
                                        (h_cnt >> 1 == block_h3 && v_cnt >> 1 == block_v3) ||
                                        (h_cnt >> 1 == block_h4 && v_cnt >> 1 == block_v4) ||
                                        (h_cnt >> 1 == block_h5 && v_cnt >> 1 == block_v5) || 
                                        (h_cnt >> 1 == block_h6 && v_cnt >> 1 == block_v6) ||
                                        (h_cnt >> 1 == block_h7 && v_cnt >> 1 == block_v7) ||
                                        (h_cnt >> 1 == block_h8 && v_cnt >> 1 == block_v8) ||
                                        (h_cnt >> 1 == block_h9 && v_cnt >> 1 == block_v9) ||
                                        (h_cnt >> 1 == block_h10 && v_cnt >> 1 == block_v10) ||
                                        (h_cnt >> 1 == block_h11 && v_cnt >> 1 == block_v11) ||
                                        (h_cnt >> 1 == block_h12 && v_cnt >> 1 == block_v12) ||
                                        (h_cnt >> 1 == block_h13 && v_cnt >> 1 == block_v13) ||
                                        (h_cnt >> 1 == block_h14 && v_cnt >> 1 == block_v14) ||
                                        (h_cnt >> 1 == block_h15 && v_cnt >> 1 == block_v15) || 
                                        (h_cnt >> 1 == block_h16 && v_cnt >> 1 == block_v16) ||
                                        (h_cnt >> 1 == block_h17 && v_cnt >> 1 == block_v17) ||
                                        (h_cnt >> 1 == block_h18 && v_cnt >> 1 == block_v18) ||
                                        (h_cnt >> 1 == block_h19 && v_cnt >> 1 == block_v19) ||
                                        (h_cnt >> 1 == block_h20 && v_cnt >> 1 == block_v20)
                                        ) 
                                             {vgaRed, vgaGreen, vgaBlue} = 12'h00b;
                                        else
                                             {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   end
                                   else if (h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end 
                              `MIDDLE : begin
                                  if ((h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 130) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 190)
                                   ) begin
                                        if ((h_cnt >> 1 == block_h && v_cnt >> 1 == block_v) ||
                                        (h_cnt >> 1 == block_h2 && v_cnt >> 1 == block_v2) ||
                                        (h_cnt >> 1 == block_h3 && v_cnt >> 1 == block_v3) ||
                                        (h_cnt >> 1 == block_h4 && v_cnt >> 1 == block_v4) ||
                                        (h_cnt >> 1 == block_h5 && v_cnt >> 1 == block_v5) || 
                                        (h_cnt >> 1 == block_h6 && v_cnt >> 1 == block_v6) ||
                                        (h_cnt >> 1 == block_h7 && v_cnt >> 1 == block_v7) ||
                                        (h_cnt >> 1 == block_h8 && v_cnt >> 1 == block_v8) ||
                                        (h_cnt >> 1 == block_h9 && v_cnt >> 1 == block_v9) ||
                                        (h_cnt >> 1 == block_h10 && v_cnt >> 1 == block_v10) ||
                                        (h_cnt >> 1 == block_h11 && v_cnt >> 1 == block_v11) ||
                                        (h_cnt >> 1 == block_h12 && v_cnt >> 1 == block_v12) ||
                                        (h_cnt >> 1 == block_h13 && v_cnt >> 1 == block_v13) ||
                                        (h_cnt >> 1 == block_h14 && v_cnt >> 1 == block_v14) ||
                                        (h_cnt >> 1 == block_h15 && v_cnt >> 1 == block_v15) || 
                                        (h_cnt >> 1 == block_h16 && v_cnt >> 1 == block_v16) ||
                                        (h_cnt >> 1 == block_h17 && v_cnt >> 1 == block_v17) ||
                                        (h_cnt >> 1 == block_h18 && v_cnt >> 1 == block_v18) ||
                                        (h_cnt >> 1 == block_h19 && v_cnt >> 1 == block_v19) ||
                                        (h_cnt >> 1 == block_h20 && v_cnt >> 1 == block_v20)
                                        ) 
                                             {vgaRed, vgaGreen, vgaBlue} = 12'h00b;
                                        else
                                             {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   end
                                   else if (h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end
                              `RIGHT : begin
                                   if ((h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 230) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 290)
                                   ) begin
                                        if ((h_cnt >> 1 == block_h && v_cnt >> 1 == block_v) ||
                                        (h_cnt >> 1 == block_h2 && v_cnt >> 1 == block_v2) ||
                                        (h_cnt >> 1 == block_h3 && v_cnt >> 1 == block_v3) ||
                                        (h_cnt >> 1 == block_h4 && v_cnt >> 1 == block_v4) ||
                                        (h_cnt >> 1 == block_h5 && v_cnt >> 1 == block_v5) || 
                                        (h_cnt >> 1 == block_h6 && v_cnt >> 1 == block_v6) ||
                                        (h_cnt >> 1 == block_h7 && v_cnt >> 1 == block_v7) ||
                                        (h_cnt >> 1 == block_h8 && v_cnt >> 1 == block_v8) ||
                                        (h_cnt >> 1 == block_h9 && v_cnt >> 1 == block_v9) ||
                                        (h_cnt >> 1 == block_h10 && v_cnt >> 1 == block_v10) ||
                                        (h_cnt >> 1 == block_h11 && v_cnt >> 1 == block_v11) ||
                                        (h_cnt >> 1 == block_h12 && v_cnt >> 1 == block_v12) ||
                                        (h_cnt >> 1 == block_h13 && v_cnt >> 1 == block_v13) ||
                                        (h_cnt >> 1 == block_h14 && v_cnt >> 1 == block_v14) ||
                                        (h_cnt >> 1 == block_h15 && v_cnt >> 1 == block_v15) || 
                                        (h_cnt >> 1 == block_h16 && v_cnt >> 1 == block_v16) ||
                                        (h_cnt >> 1 == block_h17 && v_cnt >> 1 == block_v17) ||
                                        (h_cnt >> 1 == block_h18 && v_cnt >> 1 == block_v18) ||
                                        (h_cnt >> 1 == block_h19 && v_cnt >> 1 == block_v19) ||
                                        (h_cnt >> 1 == block_h20 && v_cnt >> 1 == block_v20)
                                        ) 
                                             {vgaRed, vgaGreen, vgaBlue} = 12'h00b;
                                        else
                                             {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   end
                                   else if (h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end
                              default: 
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                         endcase
                    end
                    else 
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
               end
               `SEND_PROCESS : begin
                    if (valid) begin
                         case (pos)
                              `LEFT : begin
                                   if ((h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 30) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 90)
                                        )
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   else if (h_cnt >> 1 >= 50 && h_cnt >> 1 <= 70 && v_cnt >> 1 >= 170
                                             && v_cnt >> 1 <= 190
                                   ) begin
                                        if ((h_cnt >> 1 >= 58 && h_cnt >> 1 <= 63 && v_cnt >> 1 == 173) ||
                                        (h_cnt >> 1 >= 58 && h_cnt >> 1 <= 63 && v_cnt >> 1 == 188) ||
                                        (h_cnt >> 1 >= 58 && h_cnt >> 1 <= 63 && v_cnt >> 1 == 184) ||

                                        (h_cnt >> 1 >= 56 && h_cnt >> 1 <= 57 && v_cnt >> 1 == 174) ||
                                        (h_cnt >> 1 >= 64 && h_cnt >> 1 <= 65 && v_cnt >> 1 == 174) ||
                                        (h_cnt >> 1 >= 56 && h_cnt >> 1 <= 57 && v_cnt >> 1 == 187) ||
                                        (h_cnt >> 1 >= 64 && h_cnt >> 1 <= 65 && v_cnt >> 1 == 187) ||

                                        (v_cnt >> 1 >= 178 && v_cnt >> 1 <= 183 && h_cnt >> 1 == 53) ||
                                        (v_cnt >> 1 >= 178 && v_cnt >> 1 <= 183 && h_cnt >> 1 == 68) ||

                                        (v_cnt >> 1 >= 176 && v_cnt >> 1 <= 177 && h_cnt >> 1 == 54) ||
                                        (v_cnt >> 1 >= 176 && v_cnt >> 1 <= 177 && h_cnt >> 1 == 67) ||
                                        (v_cnt >> 1 >= 184 && v_cnt >> 1 <= 185 && h_cnt >> 1 == 54) ||
                                        (v_cnt >> 1 >= 184 && v_cnt >> 1 <= 185 && h_cnt >> 1 == 67) ||

                                        (h_cnt >> 1 >= 58 && h_cnt >> 1 <= 59 && v_cnt >> 1 >= 177 && v_cnt >> 1 <= 178) ||
                                        (h_cnt >> 1 >= 62 && h_cnt >> 1 <= 63 && v_cnt >> 1 >= 177 && v_cnt >> 1 <= 178) ||

                                        (h_cnt >> 1 == 55 && v_cnt >> 1 == 175) || (h_cnt >> 1 == 66 && v_cnt >> 1 == 175) ||
                                        (h_cnt >> 1 == 55 && v_cnt >> 1 == 186) || (h_cnt >> 1 == 66 && v_cnt >> 1 == 186) ||

                                        (h_cnt >> 1 == 56 && v_cnt >> 1 == 182) || (h_cnt >> 1 == 65 && v_cnt >> 1 == 182) ||
                                        (h_cnt >> 1 == 57 && v_cnt >> 1 == 183) || (h_cnt >> 1 == 64 && v_cnt >> 1 == 183) 

                                        )
                                             {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                        else 
                                             {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                   end
                                   else if (h_cnt >> 1 >= 30 && h_cnt >> 1 <= 90 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end 
                              `MIDDLE : begin
                                   if ((h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 130) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 190)
                                        )
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   else if (h_cnt >> 1 >= 150 && h_cnt >> 1 <= 170 && v_cnt >> 1 >= 170
                                             && v_cnt >> 1 <= 190
                                   ) begin
                                        if ((h_cnt >> 1 >= 158 && h_cnt >> 1 <= 163 && v_cnt >> 1 == 173) ||
                                        (h_cnt >> 1 >= 158 && h_cnt >> 1 <= 163 && v_cnt >> 1 == 188) ||
                                        (h_cnt >> 1 >= 158 && h_cnt >> 1 <= 163 && v_cnt >> 1 == 184) ||

                                        (h_cnt >> 1 >= 156 && h_cnt >> 1 <= 157 && v_cnt >> 1 == 174) ||
                                        (h_cnt >> 1 >= 164 && h_cnt >> 1 <= 165 && v_cnt >> 1 == 174) ||
                                        (h_cnt >> 1 >= 156 && h_cnt >> 1 <= 157 && v_cnt >> 1 == 187) ||
                                        (h_cnt >> 1 >= 164 && h_cnt >> 1 <= 165 && v_cnt >> 1 == 187) ||

                                        (v_cnt >> 1 >= 178 && v_cnt >> 1 <= 183 && h_cnt >> 1 == 153) ||
                                        (v_cnt >> 1 >= 178 && v_cnt >> 1 <= 183 && h_cnt >> 1 == 168) ||

                                        (v_cnt >> 1 >= 176 && v_cnt >> 1 <= 177 && h_cnt >> 1 == 154) ||
                                        (v_cnt >> 1 >= 176 && v_cnt >> 1 <= 177 && h_cnt >> 1 == 167) ||
                                        (v_cnt >> 1 >= 184 && v_cnt >> 1 <= 185 && h_cnt >> 1 == 154) ||
                                        (v_cnt >> 1 >= 184 && v_cnt >> 1 <= 185 && h_cnt >> 1 == 167) ||

                                        (h_cnt >> 1 >= 158 && h_cnt >> 1 <= 159 && v_cnt >> 1 >= 177 && v_cnt >> 1 <= 178) ||
                                        (h_cnt >> 1 >= 162 && h_cnt >> 1 <= 163 && v_cnt >> 1 >= 177 && v_cnt >> 1 <= 178) ||

                                        (h_cnt >> 1 == 155 && v_cnt >> 1 == 175) || (h_cnt >> 1 == 166 && v_cnt >> 1 == 175) ||
                                        (h_cnt >> 1 == 155 && v_cnt >> 1 == 186) || (h_cnt >> 1 == 166 && v_cnt >> 1 == 186) ||

                                        (h_cnt >> 1 == 156 && v_cnt >> 1 == 182) || (h_cnt >> 1 == 165 && v_cnt >> 1 == 182) ||
                                        (h_cnt >> 1 == 157 && v_cnt >> 1 == 183) || (h_cnt >> 1 == 164 && v_cnt >> 1 == 183) 

                                        )
                                             {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                        else 
                                             {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                   end
                                   else if (h_cnt >> 1 >= 130 && h_cnt >> 1 <= 190 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end
                              `RIGHT : begin
                                   if ((h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && v_cnt >> 1 == 50) ||
                                        (h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && v_cnt >> 1 == 150) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 230) ||
                                        (v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150 && h_cnt >> 1 == 290)
                                        )
                                        {vgaRed, vgaGreen, vgaBlue} = 12'hf80;
                                   else if (h_cnt >> 1 >= 250 && h_cnt >> 1 <= 270 && v_cnt >> 1 >= 170
                                             && v_cnt >> 1 <= 190
                                   ) begin
                                        if ((h_cnt >> 1 >= 258 && h_cnt >> 1 <= 263 && v_cnt >> 1 == 173) ||
                                        (h_cnt >> 1 >= 258 && h_cnt >> 1 <= 263 && v_cnt >> 1 == 188) ||
                                        (h_cnt >> 1 >= 258 && h_cnt >> 1 <= 263 && v_cnt >> 1 == 184) ||

                                        (h_cnt >> 1 >= 256 && h_cnt >> 1 <= 257 && v_cnt >> 1 == 174) ||
                                        (h_cnt >> 1 >= 264 && h_cnt >> 1 <= 265 && v_cnt >> 1 == 174) ||
                                        (h_cnt >> 1 >= 256 && h_cnt >> 1 <= 257 && v_cnt >> 1 == 187) ||
                                        (h_cnt >> 1 >= 264 && h_cnt >> 1 <= 265 && v_cnt >> 1 == 187) ||

                                        (v_cnt >> 1 >= 178 && v_cnt >> 1 <= 183 && h_cnt >> 1 == 253) ||
                                        (v_cnt >> 1 >= 178 && v_cnt >> 1 <= 183 && h_cnt >> 1 == 268) ||

                                        (v_cnt >> 1 >= 176 && v_cnt >> 1 <= 177 && h_cnt >> 1 == 254) ||
                                        (v_cnt >> 1 >= 176 && v_cnt >> 1 <= 177 && h_cnt >> 1 == 267) ||
                                        (v_cnt >> 1 >= 184 && v_cnt >> 1 <= 185 && h_cnt >> 1 == 254) ||
                                        (v_cnt >> 1 >= 184 && v_cnt >> 1 <= 185 && h_cnt >> 1 == 267) ||

                                        (h_cnt >> 1 >= 258 && h_cnt >> 1 <= 259 && v_cnt >> 1 >= 177 && v_cnt >> 1 <= 178) ||
                                        (h_cnt >> 1 >= 262 && h_cnt >> 1 <= 263 && v_cnt >> 1 >= 177 && v_cnt >> 1 <= 178) ||

                                        (h_cnt >> 1 == 255 && v_cnt >> 1 == 175) || (h_cnt >> 1 == 266 && v_cnt >> 1 == 175) ||
                                        (h_cnt >> 1 == 255 && v_cnt >> 1 == 186) || (h_cnt >> 1 == 266 && v_cnt >> 1 == 186) ||

                                        (h_cnt >> 1 == 256 && v_cnt >> 1 == 182) || (h_cnt >> 1 == 265 && v_cnt >> 1 == 182) ||
                                        (h_cnt >> 1 == 257 && v_cnt >> 1 == 183) || (h_cnt >> 1 == 264 && v_cnt >> 1 == 183) 

                                        )
                                             {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                                        else 
                                             {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                   end
                                   else if (h_cnt >> 1 >= 230 && h_cnt >> 1 <= 290 && 
                                        v_cnt >> 1 >= 50 && v_cnt >> 1 <= 150)
                                        {vgaRed, vgaGreen, vgaBlue} = pixel;
                                   else 
                                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                              end
                              default: 
                                   {vgaRed, vgaGreen, vgaBlue} = 12'h0;
                         endcase
                         
                    end
                    else 
                         {vgaRed, vgaGreen, vgaBlue} = 12'h0;
               end
          endcase
     end

     always @(*) begin
          next_block_h2 = block_h2;
          next_block_v2 = block_v2;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h2 == 10'd129 && block_v2 == 10'd50) begin
                                   next_block_h2 = 10'd31;
                                   next_block_v2 = 10'd50;
                              end
                              else if (block_h2 >= 10'd30 && block_h2 < 10'd90 && block_v2 == 10'd50) begin
                                   next_block_h2 = block_h2 + 10'd1;
                              end
                              else if (block_h2 > 10'd30 && block_h2 <= 10'd90 && block_v2 == 10'd150) begin
                                   next_block_h2 = block_h2 - 10'd1;
                              end
                              else if (block_v2 >= 10'd50 && block_v2 < 10'd150 && block_h2 == 10'd90) begin
                                   next_block_v2 = block_v2 + 10'd1;
                              end
                              else if (block_v2 > 10'd50 && block_v2 <= 10'd150 && block_h2 == 10'd30) begin
                                   next_block_v2 = block_v2 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h2 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h2 = 10'd131;
                                   next_block_v2 = 10'd50;
                              end
                              else if (block_h2 >= 10'd130 && block_h2 < 10'd190 && block_v2 == 10'd50) begin
                                   next_block_h2 = block_h2 + 10'd1;
                              end
                              else if (block_h2 > 10'd130 && block_h2 <= 10'd190 && block_v2 == 10'd150) begin
                                   next_block_h2 = block_h2 - 10'd1;
                              end
                              else if (block_v2 >= 10'd50 && block_v2 < 10'd150 && block_h2 == 10'd190) begin
                                   next_block_v2 = block_v2 + 10'd1;
                              end
                              else if (block_v2 > 10'd50 && block_v2 <= 10'd150 && block_h2 == 10'd130) begin
                                   next_block_v2 = block_v2 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h2 == 10'd129 && block_v2 == 10'd50) begin
                                   next_block_h2 = 10'd231;
                                   next_block_v2 = 10'd50;
                              end
                              else if (block_h2 >= 10'd230 && block_h2 < 10'd290 && block_v2 == 10'd50) begin
                                   next_block_h2 = block_h2 + 10'd1;
                              end
                              else if (block_h2 > 10'd230 && block_h2 <= 10'd290 && block_v2 == 10'd150) begin
                                   next_block_h2 = block_h2 - 10'd1;
                              end
                              else if (block_v2 >= 10'd50 && block_v2 < 10'd150 && block_h2 == 10'd290) begin
                                   next_block_v2 = block_v2 + 10'd1;
                              end
                              else if (block_v2 > 10'd50 && block_v2 <= 10'd150 && block_h2 == 10'd230) begin
                                   next_block_v2 = block_v2 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h2 = 10'd129;
                    next_block_v2 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h3 = block_h3;
          next_block_v3 = block_v3;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h3 == 10'd129 && block_v3 == 10'd50) begin
                                   next_block_h3 = 10'd32;
                                   next_block_v3 = 10'd50;
                              end
                              else if (block_h3 >= 10'd30 && block_h3 < 10'd90 && block_v3 == 10'd50) begin
                                   next_block_h3 = block_h3 + 10'd1;
                              end
                              else if (block_h3 > 10'd30 && block_h3 <= 10'd90 && block_v3 == 10'd150) begin
                                   next_block_h3 = block_h3 - 10'd1;
                              end
                              else if (block_v3 >= 10'd50 && block_v3 < 10'd150 && block_h3 == 10'd90) begin
                                   next_block_v3 = block_v3 + 10'd1;
                              end
                              else if (block_v3 > 10'd50 && block_v3 <= 10'd150 && block_h3 == 10'd30) begin
                                   next_block_v3 = block_v3 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h3 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h3 = 10'd132;
                                   next_block_v3 = 10'd50;
                              end
                              else if (block_h3 >= 10'd130 && block_h3 < 10'd190 && block_v3 == 10'd50) begin
                                   next_block_h3 = block_h3 + 10'd1;
                              end
                              else if (block_h3 > 10'd130 && block_h3 <= 10'd190 && block_v3 == 10'd150) begin
                                   next_block_h3 = block_h3 - 10'd1;
                              end
                              else if (block_v3 >= 10'd50 && block_v3 < 10'd150 && block_h3 == 10'd190) begin
                                   next_block_v3 = block_v3 + 10'd1;
                              end
                              else if (block_v3 > 10'd50 && block_v3 <= 10'd150 && block_h3 == 10'd130) begin
                                   next_block_v3 = block_v3 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h3 == 10'd129 && block_v3 == 10'd50) begin
                                   next_block_h3 = 10'd232;
                                   next_block_v3 = 10'd50;
                              end
                              else if (block_h3 >= 10'd230 && block_h3 < 10'd290 && block_v3 == 10'd50) begin
                                   next_block_h3 = block_h3 + 10'd1;
                              end
                              else if (block_h3 > 10'd230 && block_h3 <= 10'd290 && block_v3 == 10'd150) begin
                                   next_block_h3 = block_h3 - 10'd1;
                              end
                              else if (block_v3 >= 10'd50 && block_v3 < 10'd150 && block_h3 == 10'd290) begin
                                   next_block_v3 = block_v3 + 10'd1;
                              end
                              else if (block_v3 > 10'd50 && block_v3 <= 10'd150 && block_h3 == 10'd230) begin
                                   next_block_v3 = block_v3 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h3 = 10'd129;
                    next_block_v3 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h4 = block_h4;
          next_block_v4 = block_v4;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h4 == 10'd129 && block_v4 == 10'd50) begin
                                   next_block_h4 = 10'd33;
                                   next_block_v4 = 10'd50;
                              end
                              else if (block_h4 >= 10'd30 && block_h4 < 10'd90 && block_v4 == 10'd50) begin
                                   next_block_h4 = block_h4 + 10'd1;
                              end
                              else if (block_h4 > 10'd30 && block_h4 <= 10'd90 && block_v4 == 10'd150) begin
                                   next_block_h4 = block_h4 - 10'd1;
                              end
                              else if (block_v4 >= 10'd50 && block_v4 < 10'd150 && block_h4 == 10'd90) begin
                                   next_block_v4 = block_v4 + 10'd1;
                              end
                              else if (block_v4 > 10'd50 && block_v4 <= 10'd150 && block_h4 == 10'd30) begin
                                   next_block_v4 = block_v4 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h4 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h4 = 10'd133;
                                   next_block_v4 = 10'd50;
                              end
                              else if (block_h4 >= 10'd130 && block_h4 < 10'd190 && block_v4 == 10'd50) begin
                                   next_block_h4 = block_h4 + 10'd1;
                              end
                              else if (block_h4 > 10'd130 && block_h4 <= 10'd190 && block_v4 == 10'd150) begin
                                   next_block_h4 = block_h4 - 10'd1;
                              end
                              else if (block_v4 >= 10'd50 && block_v4 < 10'd150 && block_h4 == 10'd190) begin
                                   next_block_v4 = block_v4 + 10'd1;
                              end
                              else if (block_v4 > 10'd50 && block_v4 <= 10'd150 && block_h4 == 10'd130) begin
                                   next_block_v4 = block_v4 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h4 == 10'd129 && block_v4 == 10'd50) begin
                                   next_block_h4 = 10'd233;
                                   next_block_v4 = 10'd50;
                              end
                              else if (block_h4 >= 10'd230 && block_h4 < 10'd290 && block_v4 == 10'd50) begin
                                   next_block_h4 = block_h4 + 10'd1;
                              end
                              else if (block_h4 > 10'd230 && block_h4 <= 10'd290 && block_v4 == 10'd150) begin
                                   next_block_h4 = block_h4 - 10'd1;
                              end
                              else if (block_v4 >= 10'd50 && block_v4 < 10'd150 && block_h4 == 10'd290) begin
                                   next_block_v4 = block_v4 + 10'd1;
                              end
                              else if (block_v4 > 10'd50 && block_v4 <= 10'd150 && block_h4 == 10'd230) begin
                                   next_block_v4 = block_v4 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h4 = 10'd129;
                    next_block_v4 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h5 = block_h5;
          next_block_v5 = block_v5;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h5 == 10'd129 && block_v5 == 10'd50) begin
                                   next_block_h5 = 10'd34;
                                   next_block_v5 = 10'd50;
                              end
                              else if (block_h5 >= 10'd30 && block_h5 < 10'd90 && block_v5 == 10'd50) begin
                                   next_block_h5 = block_h5 + 10'd1;
                              end
                              else if (block_h5 > 10'd30 && block_h5 <= 10'd90 && block_v5 == 10'd150) begin
                                   next_block_h5 = block_h5 - 10'd1;
                              end
                              else if (block_v5 >= 10'd50 && block_v5 < 10'd150 && block_h5 == 10'd90) begin
                                   next_block_v5 = block_v5 + 10'd1;
                              end
                              else if (block_v5 > 10'd50 && block_v5 <= 10'd150 && block_h5 == 10'd30) begin
                                   next_block_v5 = block_v5 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h5 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h5 = 10'd134;
                                   next_block_v5 = 10'd50;
                              end
                              else if (block_h5 >= 10'd130 && block_h5 < 10'd190 && block_v5 == 10'd50) begin
                                   next_block_h5 = block_h5 + 10'd1;
                              end
                              else if (block_h5 > 10'd130 && block_h5 <= 10'd190 && block_v5 == 10'd150) begin
                                   next_block_h5 = block_h5 - 10'd1;
                              end
                              else if (block_v5 >= 10'd50 && block_v5 < 10'd150 && block_h5 == 10'd190) begin
                                   next_block_v5 = block_v5 + 10'd1;
                              end
                              else if (block_v5 > 10'd50 && block_v5 <= 10'd150 && block_h5 == 10'd130) begin
                                   next_block_v5 = block_v5 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h5 == 10'd129 && block_v5 == 10'd50) begin
                                   next_block_h5 = 10'd234;
                                   next_block_v5 = 10'd50;
                              end
                              else if (block_h5 >= 10'd230 && block_h5 < 10'd290 && block_v5 == 10'd50) begin
                                   next_block_h5 = block_h5 + 10'd1;
                              end
                              else if (block_h5 > 10'd230 && block_h5 <= 10'd290 && block_v5 == 10'd150) begin
                                   next_block_h5 = block_h5 - 10'd1;
                              end
                              else if (block_v5 >= 10'd50 && block_v5 < 10'd150 && block_h5 == 10'd290) begin
                                   next_block_v5 = block_v5 + 10'd1;
                              end
                              else if (block_v5 > 10'd50 && block_v5 <= 10'd150 && block_h5 == 10'd230) begin
                                   next_block_v5 = block_v5 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h5 = 10'd129;
                    next_block_v5 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h6 = block_h6;
          next_block_v6 = block_v6;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h6 == 10'd129 && block_v6 == 10'd50) begin
                                   next_block_h6 = 10'd35;
                                   next_block_v6 = 10'd50;
                              end
                              else if (block_h6 >= 10'd30 && block_h6 < 10'd90 && block_v6 == 10'd50) begin
                                   next_block_h6 = block_h6 + 10'd1;
                              end
                              else if (block_h6 > 10'd30 && block_h6 <= 10'd90 && block_v6 == 10'd150) begin
                                   next_block_h6 = block_h6 - 10'd1;
                              end
                              else if (block_v6 >= 10'd50 && block_v6 < 10'd150 && block_h6 == 10'd90) begin
                                   next_block_v6 = block_v6 + 10'd1;
                              end
                              else if (block_v6 > 10'd50 && block_v6 <= 10'd150 && block_h6 == 10'd30) begin
                                   next_block_v6 = block_v6 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h6 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h6 = 10'd135;
                                   next_block_v6 = 10'd50;
                              end
                              else if (block_h6 >= 10'd130 && block_h6 < 10'd190 && block_v6 == 10'd50) begin
                                   next_block_h6 = block_h6 + 10'd1;
                              end
                              else if (block_h6 > 10'd130 && block_h6 <= 10'd190 && block_v6 == 10'd150) begin
                                   next_block_h6 = block_h6 - 10'd1;
                              end
                              else if (block_v6 >= 10'd50 && block_v6 < 10'd150 && block_h6 == 10'd190) begin
                                   next_block_v6 = block_v6 + 10'd1;
                              end
                              else if (block_v6 > 10'd50 && block_v6 <= 10'd150 && block_h6 == 10'd130) begin
                                   next_block_v6 = block_v6 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h6 == 10'd129 && block_v6 == 10'd50) begin
                                   next_block_h6 = 10'd235;
                                   next_block_v6 = 10'd50;
                              end
                              else if (block_h6 >= 10'd230 && block_h6 < 10'd290 && block_v6 == 10'd50) begin
                                   next_block_h6 = block_h6 + 10'd1;
                              end
                              else if (block_h6 > 10'd230 && block_h6 <= 10'd290 && block_v6 == 10'd150) begin
                                   next_block_h6 = block_h6 - 10'd1;
                              end
                              else if (block_v6 >= 10'd50 && block_v6 < 10'd150 && block_h6 == 10'd290) begin
                                   next_block_v6 = block_v6 + 10'd1;
                              end
                              else if (block_v6 > 10'd50 && block_v6 <= 10'd150 && block_h6 == 10'd230) begin
                                   next_block_v6 = block_v6 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h6 = 10'd129;
                    next_block_v6 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h7 = block_h7;
          next_block_v7 = block_v7;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h7 == 10'd129 && block_v7 == 10'd50) begin
                                   next_block_h7 = 10'd36;
                                   next_block_v7 = 10'd50;
                              end
                              else if (block_h7 >= 10'd30 && block_h7 < 10'd90 && block_v7 == 10'd50) begin
                                   next_block_h7 = block_h7 + 10'd1;
                              end
                              else if (block_h7 > 10'd30 && block_h7 <= 10'd90 && block_v7 == 10'd150) begin
                                   next_block_h7 = block_h7 - 10'd1;
                              end
                              else if (block_v7 >= 10'd50 && block_v7 < 10'd150 && block_h7 == 10'd90) begin
                                   next_block_v7 = block_v7 + 10'd1;
                              end
                              else if (block_v7 > 10'd50 && block_v7 <= 10'd150 && block_h7 == 10'd30) begin
                                   next_block_v7 = block_v7 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h7 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h7 = 10'd136;
                                   next_block_v7 = 10'd50;
                              end
                              else if (block_h7 >= 10'd130 && block_h7 < 10'd190 && block_v7 == 10'd50) begin
                                   next_block_h7 = block_h7 + 10'd1;
                              end
                              else if (block_h7 > 10'd130 && block_h7 <= 10'd190 && block_v7 == 10'd150) begin
                                   next_block_h7 = block_h7 - 10'd1;
                              end
                              else if (block_v7 >= 10'd50 && block_v7 < 10'd150 && block_h7 == 10'd190) begin
                                   next_block_v7 = block_v7 + 10'd1;
                              end
                              else if (block_v7 > 10'd50 && block_v7 <= 10'd150 && block_h7 == 10'd130) begin
                                   next_block_v7 = block_v7 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h7 == 10'd129 && block_v7 == 10'd50) begin
                                   next_block_h7 = 10'd236;
                                   next_block_v7 = 10'd50;
                              end
                              else if (block_h7 >= 10'd230 && block_h7 < 10'd290 && block_v7 == 10'd50) begin
                                   next_block_h7 = block_h7 + 10'd1;
                              end
                              else if (block_h7 > 10'd230 && block_h7 <= 10'd290 && block_v7 == 10'd150) begin
                                   next_block_h7 = block_h7 - 10'd1;
                              end
                              else if (block_v7 >= 10'd50 && block_v7 < 10'd150 && block_h7 == 10'd290) begin
                                   next_block_v7 = block_v7 + 10'd1;
                              end
                              else if (block_v7 > 10'd50 && block_v7 <= 10'd150 && block_h7 == 10'd230) begin
                                   next_block_v7 = block_v7 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h7 = 10'd129;
                    next_block_v7 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h8 = block_h8;
          next_block_v8 = block_v8;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h8 == 10'd129 && block_v8 == 10'd50) begin
                                   next_block_h8 = 10'd37;
                                   next_block_v8 = 10'd50;
                              end
                              else if (block_h8 >= 10'd30 && block_h8 < 10'd90 && block_v8 == 10'd50) begin
                                   next_block_h8 = block_h8 + 10'd1;
                              end
                              else if (block_h8 > 10'd30 && block_h8 <= 10'd90 && block_v8 == 10'd150) begin
                                   next_block_h8 = block_h8 - 10'd1;
                              end
                              else if (block_v8 >= 10'd50 && block_v8 < 10'd150 && block_h8 == 10'd90) begin
                                   next_block_v8 = block_v8 + 10'd1;
                              end
                              else if (block_v8 > 10'd50 && block_v8 <= 10'd150 && block_h8 == 10'd30) begin
                                   next_block_v8 = block_v8 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h8 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h8 = 10'd137;
                                   next_block_v8 = 10'd50;
                              end
                              else if (block_h8 >= 10'd130 && block_h8 < 10'd190 && block_v8 == 10'd50) begin
                                   next_block_h8 = block_h8 + 10'd1;
                              end
                              else if (block_h8 > 10'd130 && block_h8 <= 10'd190 && block_v8 == 10'd150) begin
                                   next_block_h8 = block_h8 - 10'd1;
                              end
                              else if (block_v8 >= 10'd50 && block_v8 < 10'd150 && block_h8 == 10'd190) begin
                                   next_block_v8 = block_v8 + 10'd1;
                              end
                              else if (block_v8 > 10'd50 && block_v8 <= 10'd150 && block_h8 == 10'd130) begin
                                   next_block_v8 = block_v8 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h8 == 10'd129 && block_v8 == 10'd50) begin
                                   next_block_h8 = 10'd237;
                                   next_block_v8 = 10'd50;
                              end
                              else if (block_h8 >= 10'd230 && block_h8 < 10'd290 && block_v8 == 10'd50) begin
                                   next_block_h8 = block_h8 + 10'd1;
                              end
                              else if (block_h8 > 10'd230 && block_h8 <= 10'd290 && block_v8 == 10'd150) begin
                                   next_block_h8 = block_h8 - 10'd1;
                              end
                              else if (block_v8 >= 10'd50 && block_v8 < 10'd150 && block_h8 == 10'd290) begin
                                   next_block_v8 = block_v8 + 10'd1;
                              end
                              else if (block_v8 > 10'd50 && block_v8 <= 10'd150 && block_h8 == 10'd230) begin
                                   next_block_v8 = block_v8 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h8 = 10'd129;
                    next_block_v8 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h9 = block_h9;
          next_block_v9 = block_v9;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h9 == 10'd129 && block_v9 == 10'd50) begin
                                   next_block_h9 = 10'd38;
                                   next_block_v9 = 10'd50;
                              end
                              else if (block_h9 >= 10'd30 && block_h9 < 10'd90 && block_v9 == 10'd50) begin
                                   next_block_h9 = block_h9 + 10'd1;
                              end
                              else if (block_h9 > 10'd30 && block_h9 <= 10'd90 && block_v9 == 10'd150) begin
                                   next_block_h9 = block_h9 - 10'd1;
                              end
                              else if (block_v9 >= 10'd50 && block_v9 < 10'd150 && block_h9 == 10'd90) begin
                                   next_block_v9 = block_v9 + 10'd1;
                              end
                              else if (block_v9 > 10'd50 && block_v9 <= 10'd150 && block_h9 == 10'd30) begin
                                   next_block_v9 = block_v9 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h9 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h9 = 10'd138;
                                   next_block_v9 = 10'd50;
                              end
                              else if (block_h9 >= 10'd130 && block_h9 < 10'd190 && block_v9 == 10'd50) begin
                                   next_block_h9 = block_h9 + 10'd1;
                              end
                              else if (block_h9 > 10'd130 && block_h9 <= 10'd190 && block_v9 == 10'd150) begin
                                   next_block_h9 = block_h9 - 10'd1;
                              end
                              else if (block_v9 >= 10'd50 && block_v9 < 10'd150 && block_h9 == 10'd190) begin
                                   next_block_v9 = block_v9 + 10'd1;
                              end
                              else if (block_v9 > 10'd50 && block_v9 <= 10'd150 && block_h9 == 10'd130) begin
                                   next_block_v9 = block_v9 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h9 == 10'd129 && block_v9 == 10'd50) begin
                                   next_block_h9 = 10'd238;
                                   next_block_v9 = 10'd50;
                              end
                              else if (block_h9 >= 10'd230 && block_h9 < 10'd290 && block_v9 == 10'd50) begin
                                   next_block_h9 = block_h9 + 10'd1;
                              end
                              else if (block_h9 > 10'd230 && block_h9 <= 10'd290 && block_v9 == 10'd150) begin
                                   next_block_h9 = block_h9 - 10'd1;
                              end
                              else if (block_v9 >= 10'd50 && block_v9 < 10'd150 && block_h9 == 10'd290) begin
                                   next_block_v9 = block_v9 + 10'd1;
                              end
                              else if (block_v9 > 10'd50 && block_v9 <= 10'd150 && block_h9 == 10'd230) begin
                                   next_block_v9 = block_v9 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h9 = 10'd129;
                    next_block_v9 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h10 = block_h10;
          next_block_v10 = block_v10;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h10 == 10'd129 && block_v10 == 10'd50) begin
                                   next_block_h10 = 10'd39;
                                   next_block_v10 = 10'd50;
                              end
                              else if (block_h10 >= 10'd30 && block_h10 < 10'd90 && block_v10 == 10'd50) begin
                                   next_block_h10 = block_h10 + 10'd1;
                              end
                              else if (block_h10 > 10'd30 && block_h10 <= 10'd90 && block_v10 == 10'd150) begin
                                   next_block_h10 = block_h10 - 10'd1;
                              end
                              else if (block_v10 >= 10'd50 && block_v10 < 10'd150 && block_h10 == 10'd90) begin
                                   next_block_v10 = block_v10 + 10'd1;
                              end
                              else if (block_v10 > 10'd50 && block_v10 <= 10'd150 && block_h10 == 10'd30) begin
                                   next_block_v10 = block_v10 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h10 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h10 = 10'd139;
                                   next_block_v10 = 10'd50;
                              end
                              else if (block_h10 >= 10'd130 && block_h10 < 10'd190 && block_v10 == 10'd50) begin
                                   next_block_h10 = block_h10 + 10'd1;
                              end
                              else if (block_h10 > 10'd130 && block_h10 <= 10'd190 && block_v10 == 10'd150) begin
                                   next_block_h10 = block_h10 - 10'd1;
                              end
                              else if (block_v10 >= 10'd50 && block_v10 < 10'd150 && block_h10 == 10'd190) begin
                                   next_block_v10 = block_v10 + 10'd1;
                              end
                              else if (block_v10 > 10'd50 && block_v10 <= 10'd150 && block_h10 == 10'd130) begin
                                   next_block_v10 = block_v10 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h10 == 10'd129 && block_v10 == 10'd50) begin
                                   next_block_h10 = 10'd239;
                                   next_block_v10 = 10'd50;
                              end
                              else if (block_h10 >= 10'd230 && block_h10 < 10'd290 && block_v10 == 10'd50) begin
                                   next_block_h10 = block_h10 + 10'd1;
                              end
                              else if (block_h10 > 10'd230 && block_h10 <= 10'd290 && block_v10 == 10'd150) begin
                                   next_block_h10 = block_h10 - 10'd1;
                              end
                              else if (block_v10 >= 10'd50 && block_v10 < 10'd150 && block_h10 == 10'd290) begin
                                   next_block_v10 = block_v10 + 10'd1;
                              end
                              else if (block_v10 > 10'd50 && block_v10 <= 10'd150 && block_h10 == 10'd230) begin
                                   next_block_v10 = block_v10 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h10 = 10'd129;
                    next_block_v10 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h11 = block_h11;
          next_block_v11 = block_v11;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h11 == 10'd129 && block_v11 == 10'd50) begin
                                   next_block_h11 = 10'd40;
                                   next_block_v11 = 10'd50;
                              end
                              else if (block_h11 >= 10'd30 && block_h11 < 10'd90 && block_v11 == 10'd50) begin
                                   next_block_h11 = block_h11 + 10'd1;
                              end
                              else if (block_h11 > 10'd30 && block_h11 <= 10'd90 && block_v11 == 10'd150) begin
                                   next_block_h11 = block_h11 - 10'd1;
                              end
                              else if (block_v11 >= 10'd50 && block_v11 < 10'd150 && block_h11 == 10'd90) begin
                                   next_block_v11 = block_v11 + 10'd1;
                              end
                              else if (block_v11 > 10'd50 && block_v11 <= 10'd150 && block_h11 == 10'd30) begin
                                   next_block_v11 = block_v11 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h11 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h11 = 10'd140;
                                   next_block_v11 = 10'd50;
                              end
                              else if (block_h11 >= 10'd130 && block_h11 < 10'd190 && block_v11 == 10'd50) begin
                                   next_block_h11 = block_h11 + 10'd1;
                              end
                              else if (block_h11 > 10'd130 && block_h11 <= 10'd190 && block_v11 == 10'd150) begin
                                   next_block_h11 = block_h11 - 10'd1;
                              end
                              else if (block_v11 >= 10'd50 && block_v11 < 10'd150 && block_h11 == 10'd190) begin
                                   next_block_v11 = block_v11 + 10'd1;
                              end
                              else if (block_v11 > 10'd50 && block_v11 <= 10'd150 && block_h11 == 10'd130) begin
                                   next_block_v11 = block_v11 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h11 == 10'd129 && block_v11 == 10'd50) begin
                                   next_block_h11 = 10'd240;
                                   next_block_v11 = 10'd50;
                              end
                              else if (block_h11 >= 10'd230 && block_h11 < 10'd290 && block_v11 == 10'd50) begin
                                   next_block_h11 = block_h11 + 10'd1;
                              end
                              else if (block_h11 > 10'd230 && block_h11 <= 10'd290 && block_v11 == 10'd150) begin
                                   next_block_h11 = block_h11 - 10'd1;
                              end
                              else if (block_v11 >= 10'd50 && block_v11 < 10'd150 && block_h11 == 10'd290) begin
                                   next_block_v11 = block_v11 + 10'd1;
                              end
                              else if (block_v11 > 10'd50 && block_v11 <= 10'd150 && block_h11 == 10'd230) begin
                                   next_block_v11 = block_v11 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h11 = 10'd129;
                    next_block_v11 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h12 = block_h12;
          next_block_v12 = block_v12;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h12 == 10'd129 && block_v12 == 10'd50) begin
                                   next_block_h12 = 10'd41;
                                   next_block_v12 = 10'd50;
                              end
                              else if (block_h12 >= 10'd30 && block_h12 < 10'd90 && block_v12 == 10'd50) begin
                                   next_block_h12 = block_h12 + 10'd1;
                              end
                              else if (block_h12 > 10'd30 && block_h12 <= 10'd90 && block_v12 == 10'd150) begin
                                   next_block_h12 = block_h12 - 10'd1;
                              end
                              else if (block_v12 >= 10'd50 && block_v12 < 10'd150 && block_h12 == 10'd90) begin
                                   next_block_v12 = block_v12 + 10'd1;
                              end
                              else if (block_v12 > 10'd50 && block_v12 <= 10'd150 && block_h12 == 10'd30) begin
                                   next_block_v12 = block_v12 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h12 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h12 = 10'd141;
                                   next_block_v12 = 10'd50;
                              end
                              else if (block_h12 >= 10'd130 && block_h12 < 10'd190 && block_v12 == 10'd50) begin
                                   next_block_h12 = block_h12 + 10'd1;
                              end
                              else if (block_h12 > 10'd130 && block_h12 <= 10'd190 && block_v12 == 10'd150) begin
                                   next_block_h12 = block_h12 - 10'd1;
                              end
                              else if (block_v12 >= 10'd50 && block_v12 < 10'd150 && block_h12 == 10'd190) begin
                                   next_block_v12 = block_v12 + 10'd1;
                              end
                              else if (block_v12 > 10'd50 && block_v12 <= 10'd150 && block_h12 == 10'd130) begin
                                   next_block_v12 = block_v12 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h12 == 10'd129 && block_v12 == 10'd50) begin
                                   next_block_h12 = 10'd241;
                                   next_block_v12 = 10'd50;
                              end
                              else if (block_h12 >= 10'd230 && block_h12 < 10'd290 && block_v12 == 10'd50) begin
                                   next_block_h12 = block_h12 + 10'd1;
                              end
                              else if (block_h12 > 10'd230 && block_h12 <= 10'd290 && block_v12 == 10'd150) begin
                                   next_block_h12 = block_h12 - 10'd1;
                              end
                              else if (block_v12 >= 10'd50 && block_v12 < 10'd150 && block_h12 == 10'd290) begin
                                   next_block_v12 = block_v12 + 10'd1;
                              end
                              else if (block_v12 > 10'd50 && block_v12 <= 10'd150 && block_h12 == 10'd230) begin
                                   next_block_v12 = block_v12 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h12 = 10'd129;
                    next_block_v12 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h13 = block_h13;
          next_block_v13 = block_v13;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h13 == 10'd129 && block_v13 == 10'd50) begin
                                   next_block_h13 = 10'd42;
                                   next_block_v13 = 10'd50;
                              end
                              else if (block_h13 >= 10'd30 && block_h13 < 10'd90 && block_v13 == 10'd50) begin
                                   next_block_h13 = block_h13 + 10'd1;
                              end
                              else if (block_h13 > 10'd30 && block_h13 <= 10'd90 && block_v13 == 10'd150) begin
                                   next_block_h13 = block_h13 - 10'd1;
                              end
                              else if (block_v13 >= 10'd50 && block_v13 < 10'd150 && block_h13 == 10'd90) begin
                                   next_block_v13 = block_v13 + 10'd1;
                              end
                              else if (block_v13 > 10'd50 && block_v13 <= 10'd150 && block_h13 == 10'd30) begin
                                   next_block_v13 = block_v13 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h13 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h13 = 10'd142;
                                   next_block_v13 = 10'd50;
                              end
                              else if (block_h13 >= 10'd130 && block_h13 < 10'd190 && block_v13 == 10'd50) begin
                                   next_block_h13 = block_h13 + 10'd1;
                              end
                              else if (block_h13 > 10'd130 && block_h13 <= 10'd190 && block_v13 == 10'd150) begin
                                   next_block_h13 = block_h13 - 10'd1;
                              end
                              else if (block_v13 >= 10'd50 && block_v13 < 10'd150 && block_h13 == 10'd190) begin
                                   next_block_v13 = block_v13 + 10'd1;
                              end
                              else if (block_v13 > 10'd50 && block_v13 <= 10'd150 && block_h13 == 10'd130) begin
                                   next_block_v13 = block_v13 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h13 == 10'd129 && block_v13 == 10'd50) begin
                                   next_block_h13 = 10'd242;
                                   next_block_v13 = 10'd50;
                              end
                              else if (block_h13 >= 10'd230 && block_h13 < 10'd290 && block_v13 == 10'd50) begin
                                   next_block_h13 = block_h13 + 10'd1;
                              end
                              else if (block_h13 > 10'd230 && block_h13 <= 10'd290 && block_v13 == 10'd150) begin
                                   next_block_h13 = block_h13 - 10'd1;
                              end
                              else if (block_v13 >= 10'd50 && block_v13 < 10'd150 && block_h13 == 10'd290) begin
                                   next_block_v13 = block_v13 + 10'd1;
                              end
                              else if (block_v13 > 10'd50 && block_v13 <= 10'd150 && block_h13 == 10'd230) begin
                                   next_block_v13 = block_v13 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h13 = 10'd129;
                    next_block_v13 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h14 = block_h14;
          next_block_v14 = block_v14;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h14 == 10'd129 && block_v14 == 10'd50) begin
                                   next_block_h14 = 10'd43;
                                   next_block_v14 = 10'd50;
                              end
                              else if (block_h14 >= 10'd30 && block_h14 < 10'd90 && block_v14 == 10'd50) begin
                                   next_block_h14 = block_h14 + 10'd1;
                              end
                              else if (block_h14 > 10'd30 && block_h14 <= 10'd90 && block_v14 == 10'd150) begin
                                   next_block_h14 = block_h14 - 10'd1;
                              end
                              else if (block_v14 >= 10'd50 && block_v14 < 10'd150 && block_h14 == 10'd90) begin
                                   next_block_v14 = block_v14 + 10'd1;
                              end
                              else if (block_v14 > 10'd50 && block_v14 <= 10'd150 && block_h14 == 10'd30) begin
                                   next_block_v14 = block_v14 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h14 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h14 = 10'd143;
                                   next_block_v14 = 10'd50;
                              end
                              else if (block_h14 >= 10'd130 && block_h14 < 10'd190 && block_v14 == 10'd50) begin
                                   next_block_h14 = block_h14 + 10'd1;
                              end
                              else if (block_h14 > 10'd130 && block_h14 <= 10'd190 && block_v14 == 10'd150) begin
                                   next_block_h14 = block_h14 - 10'd1;
                              end
                              else if (block_v14 >= 10'd50 && block_v14 < 10'd150 && block_h14 == 10'd190) begin
                                   next_block_v14 = block_v14 + 10'd1;
                              end
                              else if (block_v14 > 10'd50 && block_v14 <= 10'd150 && block_h14 == 10'd130) begin
                                   next_block_v14 = block_v14 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h14 == 10'd129 && block_v14 == 10'd50) begin
                                   next_block_h14 = 10'd243;
                                   next_block_v14 = 10'd50;
                              end
                              else if (block_h14 >= 10'd230 && block_h14 < 10'd290 && block_v14 == 10'd50) begin
                                   next_block_h14 = block_h14 + 10'd1;
                              end
                              else if (block_h14 > 10'd230 && block_h14 <= 10'd290 && block_v14 == 10'd150) begin
                                   next_block_h14 = block_h14 - 10'd1;
                              end
                              else if (block_v14 >= 10'd50 && block_v14 < 10'd150 && block_h14 == 10'd290) begin
                                   next_block_v14 = block_v14 + 10'd1;
                              end
                              else if (block_v14 > 10'd50 && block_v14 <= 10'd150 && block_h14 == 10'd230) begin
                                   next_block_v14 = block_v14 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h14 = 10'd129;
                    next_block_v14 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h15 = block_h15;
          next_block_v15 = block_v15;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h15 == 10'd129 && block_v15 == 10'd50) begin
                                   next_block_h15 = 10'd44;
                                   next_block_v15 = 10'd50;
                              end
                              else if (block_h15 >= 10'd30 && block_h15 < 10'd90 && block_v15 == 10'd50) begin
                                   next_block_h15 = block_h15 + 10'd1;
                              end
                              else if (block_h15 > 10'd30 && block_h15 <= 10'd90 && block_v15 == 10'd150) begin
                                   next_block_h15 = block_h15 - 10'd1;
                              end
                              else if (block_v15 >= 10'd50 && block_v15 < 10'd150 && block_h15 == 10'd90) begin
                                   next_block_v15 = block_v15 + 10'd1;
                              end
                              else if (block_v15 > 10'd50 && block_v15 <= 10'd150 && block_h15 == 10'd30) begin
                                   next_block_v15 = block_v15 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h15 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h15 = 10'd144;
                                   next_block_v15 = 10'd50;
                              end
                              else if (block_h15 >= 10'd130 && block_h15 < 10'd190 && block_v15 == 10'd50) begin
                                   next_block_h15 = block_h15 + 10'd1;
                              end
                              else if (block_h15 > 10'd130 && block_h15 <= 10'd190 && block_v15 == 10'd150) begin
                                   next_block_h15 = block_h15 - 10'd1;
                              end
                              else if (block_v15 >= 10'd50 && block_v15 < 10'd150 && block_h15 == 10'd190) begin
                                   next_block_v15 = block_v15 + 10'd1;
                              end
                              else if (block_v15 > 10'd50 && block_v15 <= 10'd150 && block_h15 == 10'd130) begin
                                   next_block_v15 = block_v15 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h15 == 10'd129 && block_v15 == 10'd50) begin
                                   next_block_h15 = 10'd244;
                                   next_block_v15 = 10'd50;
                              end
                              else if (block_h15 >= 10'd230 && block_h15 < 10'd290 && block_v15 == 10'd50) begin
                                   next_block_h15 = block_h15 + 10'd1;
                              end
                              else if (block_h15 > 10'd230 && block_h15 <= 10'd290 && block_v15 == 10'd150) begin
                                   next_block_h15 = block_h15 - 10'd1;
                              end
                              else if (block_v15 >= 10'd50 && block_v15 < 10'd150 && block_h15 == 10'd290) begin
                                   next_block_v15 = block_v15 + 10'd1;
                              end
                              else if (block_v15 > 10'd50 && block_v15 <= 10'd150 && block_h15 == 10'd230) begin
                                   next_block_v15 = block_v15 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h15 = 10'd129;
                    next_block_v15 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h16 = block_h16;
          next_block_v16 = block_v16;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h16 == 10'd129 && block_v16 == 10'd50) begin
                                   next_block_h16 = 10'd45;
                                   next_block_v16 = 10'd50;
                              end
                              else if (block_h16 >= 10'd30 && block_h16 < 10'd90 && block_v16 == 10'd50) begin
                                   next_block_h16 = block_h16 + 10'd1;
                              end
                              else if (block_h16 > 10'd30 && block_h16 <= 10'd90 && block_v16 == 10'd150) begin
                                   next_block_h16 = block_h16 - 10'd1;
                              end
                              else if (block_v16 >= 10'd50 && block_v16 < 10'd150 && block_h16 == 10'd90) begin
                                   next_block_v16 = block_v16 + 10'd1;
                              end
                              else if (block_v16 > 10'd50 && block_v16 <= 10'd150 && block_h16 == 10'd30) begin
                                   next_block_v16 = block_v16 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h16 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h16 = 10'd145;
                                   next_block_v16 = 10'd50;
                              end
                              else if (block_h16 >= 10'd130 && block_h16 < 10'd190 && block_v16 == 10'd50) begin
                                   next_block_h16 = block_h16 + 10'd1;
                              end
                              else if (block_h16 > 10'd130 && block_h16 <= 10'd190 && block_v16 == 10'd150) begin
                                   next_block_h16 = block_h16 - 10'd1;
                              end
                              else if (block_v16 >= 10'd50 && block_v16 < 10'd150 && block_h16 == 10'd190) begin
                                   next_block_v16 = block_v16 + 10'd1;
                              end
                              else if (block_v16 > 10'd50 && block_v16 <= 10'd150 && block_h16 == 10'd130) begin
                                   next_block_v16 = block_v16 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h16 == 10'd129 && block_v16 == 10'd50) begin
                                   next_block_h16 = 10'd245;
                                   next_block_v16 = 10'd50;
                              end
                              else if (block_h16 >= 10'd230 && block_h16 < 10'd290 && block_v16 == 10'd50) begin
                                   next_block_h16 = block_h16 + 10'd1;
                              end
                              else if (block_h16 > 10'd230 && block_h16 <= 10'd290 && block_v16 == 10'd150) begin
                                   next_block_h16 = block_h16 - 10'd1;
                              end
                              else if (block_v16 >= 10'd50 && block_v16 < 10'd150 && block_h16 == 10'd290) begin
                                   next_block_v16 = block_v16 + 10'd1;
                              end
                              else if (block_v16 > 10'd50 && block_v16 <= 10'd150 && block_h16 == 10'd230) begin
                                   next_block_v16 = block_v16 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h16 = 10'd129;
                    next_block_v16 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h17 = block_h17;
          next_block_v17 = block_v17;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h17 == 10'd129 && block_v17 == 10'd50) begin
                                   next_block_h17 = 10'd46;
                                   next_block_v17 = 10'd50;
                              end
                              else if (block_h17 >= 10'd30 && block_h17 < 10'd90 && block_v17 == 10'd50) begin
                                   next_block_h17 = block_h17 + 10'd1;
                              end
                              else if (block_h17 > 10'd30 && block_h17 <= 10'd90 && block_v17 == 10'd150) begin
                                   next_block_h17 = block_h17 - 10'd1;
                              end
                              else if (block_v17 >= 10'd50 && block_v17 < 10'd150 && block_h17 == 10'd90) begin
                                   next_block_v17 = block_v17 + 10'd1;
                              end
                              else if (block_v17 > 10'd50 && block_v17 <= 10'd150 && block_h17 == 10'd30) begin
                                   next_block_v17 = block_v17 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h17 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h17 = 10'd146;
                                   next_block_v17 = 10'd50;
                              end
                              else if (block_h17 >= 10'd130 && block_h17 < 10'd190 && block_v17 == 10'd50) begin
                                   next_block_h17 = block_h17 + 10'd1;
                              end
                              else if (block_h17 > 10'd130 && block_h17 <= 10'd190 && block_v17 == 10'd150) begin
                                   next_block_h17 = block_h17 - 10'd1;
                              end
                              else if (block_v17 >= 10'd50 && block_v17 < 10'd150 && block_h17 == 10'd190) begin
                                   next_block_v17 = block_v17 + 10'd1;
                              end
                              else if (block_v17 > 10'd50 && block_v17 <= 10'd150 && block_h17 == 10'd130) begin
                                   next_block_v17 = block_v17 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h17 == 10'd129 && block_v17 == 10'd50) begin
                                   next_block_h17 = 10'd246;
                                   next_block_v17 = 10'd50;
                              end
                              else if (block_h17 >= 10'd230 && block_h17 < 10'd290 && block_v17 == 10'd50) begin
                                   next_block_h17 = block_h17 + 10'd1;
                              end
                              else if (block_h17 > 10'd230 && block_h17 <= 10'd290 && block_v17 == 10'd150) begin
                                   next_block_h17 = block_h17 - 10'd1;
                              end
                              else if (block_v17 >= 10'd50 && block_v17 < 10'd150 && block_h17 == 10'd290) begin
                                   next_block_v17 = block_v17 + 10'd1;
                              end
                              else if (block_v17 > 10'd50 && block_v17 <= 10'd150 && block_h17 == 10'd230) begin
                                   next_block_v17 = block_v17 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h17 = 10'd129;
                    next_block_v17 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h18 = block_h18;
          next_block_v18 = block_v18;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h18 == 10'd129 && block_v18 == 10'd50) begin
                                   next_block_h18 = 10'd47;
                                   next_block_v18 = 10'd50;
                              end
                              else if (block_h18 >= 10'd30 && block_h18 < 10'd90 && block_v18 == 10'd50) begin
                                   next_block_h18 = block_h18 + 10'd1;
                              end
                              else if (block_h18 > 10'd30 && block_h18 <= 10'd90 && block_v18 == 10'd150) begin
                                   next_block_h18 = block_h18 - 10'd1;
                              end
                              else if (block_v18 >= 10'd50 && block_v18 < 10'd150 && block_h18 == 10'd90) begin
                                   next_block_v18 = block_v18 + 10'd1;
                              end
                              else if (block_v18 > 10'd50 && block_v18 <= 10'd150 && block_h18 == 10'd30) begin
                                   next_block_v18 = block_v18 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h18 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h18 = 10'd147;
                                   next_block_v18 = 10'd50;
                              end
                              else if (block_h18 >= 10'd130 && block_h18 < 10'd190 && block_v18 == 10'd50) begin
                                   next_block_h18 = block_h18 + 10'd1;
                              end
                              else if (block_h18 > 10'd130 && block_h18 <= 10'd190 && block_v18 == 10'd150) begin
                                   next_block_h18 = block_h18 - 10'd1;
                              end
                              else if (block_v18 >= 10'd50 && block_v18 < 10'd150 && block_h18 == 10'd190) begin
                                   next_block_v18 = block_v18 + 10'd1;
                              end
                              else if (block_v18 > 10'd50 && block_v18 <= 10'd150 && block_h18 == 10'd130) begin
                                   next_block_v18 = block_v18 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h18 == 10'd129 && block_v18 == 10'd50) begin
                                   next_block_h18 = 10'd247;
                                   next_block_v18 = 10'd50;
                              end
                              else if (block_h18 >= 10'd230 && block_h18 < 10'd290 && block_v18 == 10'd50) begin
                                   next_block_h18 = block_h18 + 10'd1;
                              end
                              else if (block_h18 > 10'd230 && block_h18 <= 10'd290 && block_v18 == 10'd150) begin
                                   next_block_h18 = block_h18 - 10'd1;
                              end
                              else if (block_v18 >= 10'd50 && block_v18 < 10'd150 && block_h18 == 10'd290) begin
                                   next_block_v18 = block_v18 + 10'd1;
                              end
                              else if (block_v18 > 10'd50 && block_v18 <= 10'd150 && block_h18 == 10'd230) begin
                                   next_block_v18 = block_v18 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h18 = 10'd129;
                    next_block_v18 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h19 = block_h19;
          next_block_v19 = block_v19;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h19 == 10'd129 && block_v19 == 10'd50) begin
                                   next_block_h19 = 10'd48;
                                   next_block_v19 = 10'd50;
                              end
                              else if (block_h19 >= 10'd30 && block_h19 < 10'd90 && block_v19 == 10'd50) begin
                                   next_block_h19 = block_h19 + 10'd1;
                              end
                              else if (block_h19 > 10'd30 && block_h19 <= 10'd90 && block_v19 == 10'd150) begin
                                   next_block_h19 = block_h19 - 10'd1;
                              end
                              else if (block_v19 >= 10'd50 && block_v19 < 10'd150 && block_h19 == 10'd90) begin
                                   next_block_v19 = block_v19 + 10'd1;
                              end
                              else if (block_v19 > 10'd50 && block_v19 <= 10'd150 && block_h19 == 10'd30) begin
                                   next_block_v19 = block_v19 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h19 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h19 = 10'd148;
                                   next_block_v19 = 10'd50;
                              end
                              else if (block_h19 >= 10'd130 && block_h19 < 10'd190 && block_v19 == 10'd50) begin
                                   next_block_h19 = block_h19 + 10'd1;
                              end
                              else if (block_h19 > 10'd130 && block_h19 <= 10'd190 && block_v19 == 10'd150) begin
                                   next_block_h19 = block_h19 - 10'd1;
                              end
                              else if (block_v19 >= 10'd50 && block_v19 < 10'd150 && block_h19 == 10'd190) begin
                                   next_block_v19 = block_v19 + 10'd1;
                              end
                              else if (block_v19 > 10'd50 && block_v19 <= 10'd150 && block_h19 == 10'd130) begin
                                   next_block_v19 = block_v19 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h19 == 10'd129 && block_v19 == 10'd50) begin
                                   next_block_h19 = 10'd248;
                                   next_block_v19 = 10'd50;
                              end
                              else if (block_h19 >= 10'd230 && block_h19 < 10'd290 && block_v19 == 10'd50) begin
                                   next_block_h19 = block_h19 + 10'd1;
                              end
                              else if (block_h19 > 10'd230 && block_h19 <= 10'd290 && block_v19 == 10'd150) begin
                                   next_block_h19 = block_h19 - 10'd1;
                              end
                              else if (block_v19 >= 10'd50 && block_v19 < 10'd150 && block_h19 == 10'd290) begin
                                   next_block_v19 = block_v19 + 10'd1;
                              end
                              else if (block_v19 > 10'd50 && block_v19 <= 10'd150 && block_h19 == 10'd230) begin
                                   next_block_v19 = block_v19 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h19 = 10'd129;
                    next_block_v19 = 10'd50;
               end 
          endcase
     end

     always @(*) begin
          next_block_h20 = block_h20;
          next_block_v20 = block_v20;
          case (state)
               `PAY : begin
                    case (pos)
                         `LEFT : begin
                              if (block_h20 == 10'd129 && block_v20 == 10'd50) begin
                                   next_block_h20 = 10'd49;
                                   next_block_v20 = 10'd50;
                              end
                              else if (block_h20 >= 10'd30 && block_h20 < 10'd90 && block_v20 == 10'd50) begin
                                   next_block_h20 = block_h20 + 10'd1;
                              end
                              else if (block_h20 > 10'd30 && block_h20 <= 10'd90 && block_v20 == 10'd150) begin
                                   next_block_h20 = block_h20 - 10'd1;
                              end
                              else if (block_v20 >= 10'd50 && block_v20 < 10'd150 && block_h20 == 10'd90) begin
                                   next_block_v20 = block_v20 + 10'd1;
                              end
                              else if (block_v20 > 10'd50 && block_v20 <= 10'd150 && block_h20 == 10'd30) begin
                                   next_block_v20 = block_v20 - 10'd1;
                              end
                         end
                         `MIDDLE : begin
                              if (block_h20 == 10'd129 && block_v == 10'd50) begin
                                   next_block_h20 = 10'd149;
                                   next_block_v20 = 10'd50;
                              end
                              else if (block_h20 >= 10'd130 && block_h20 < 10'd190 && block_v20 == 10'd50) begin
                                   next_block_h20 = block_h20 + 10'd1;
                              end
                              else if (block_h20 > 10'd130 && block_h20 <= 10'd190 && block_v20 == 10'd150) begin
                                   next_block_h20 = block_h20 - 10'd1;
                              end
                              else if (block_v20 >= 10'd50 && block_v20 < 10'd150 && block_h20 == 10'd190) begin
                                   next_block_v20 = block_v20 + 10'd1;
                              end
                              else if (block_v20 > 10'd50 && block_v20 <= 10'd150 && block_h20 == 10'd130) begin
                                   next_block_v20 = block_v20 - 10'd1;
                              end
                         end
                         `RIGHT : begin
                              if (block_h20 == 10'd129 && block_v20 == 10'd50) begin
                                   next_block_h20 = 10'd249;
                                   next_block_v20 = 10'd50;
                              end
                              else if (block_h20 >= 10'd230 && block_h20 < 10'd290 && block_v20 == 10'd50) begin
                                   next_block_h20 = block_h20 + 10'd1;
                              end
                              else if (block_h20 > 10'd230 && block_h20 <= 10'd290 && block_v20 == 10'd150) begin
                                   next_block_h20 = block_h20 - 10'd1;
                              end
                              else if (block_v20 >= 10'd50 && block_v20 < 10'd150 && block_h20 == 10'd290) begin
                                   next_block_v20 = block_v20 + 10'd1;
                              end
                              else if (block_v20 > 10'd50 && block_v20 <= 10'd150 && block_h20 == 10'd230) begin
                                   next_block_v20 = block_v20 - 10'd1;
                              end
                         end
                         default : begin
                              
                         end
                    endcase
               end 
               default: begin
                    next_block_h20 = 10'd129;
                    next_block_v20 = 10'd50;
               end 
          endcase
     end

endmodule
