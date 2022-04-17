module lab1_2 (a, b, c, aluctr, d, e);
    input a, b, c;
    input [1:0] aluctr;
    output d, e;
    wire tmp_d, tmp_e;
    wire and_ab, nor_ab, xor_ab;

    assign {tmp_e, tmp_d} = a + b + c;
    assign and_ab = a & b;
    assign xor_ab = a ^ b;
    assign nor_ab = ~(a | b);

    /* e part */
   assign e = (aluctr == 2'b00) ? tmp_e : 1'b0;

    /* d part */ 
    assign d = (aluctr == 2'b00) ? tmp_d : (aluctr == 2'b01) ? and_ab : (aluctr == 2'b10) ? nor_ab : xor_ab;

endmodule;