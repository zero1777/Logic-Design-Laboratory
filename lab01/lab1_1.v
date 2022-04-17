module myxor (out, a, b);
    input a, b;
    output out;
    wire not_a, not_b;
    wire tmp1, tmp2;

    // build not gate
    not not0(not_a, a);
    not not1(not_b, b);

    // use not gate with and gate
    and and0(tmp1, not_a, b);
    and and1(tmp2, not_b, a);

    // combine tmp1 and tmp2 with or gate
    or or0(out, tmp1, tmp2);
endmodule

module mux4_to_1(
    q_o,
    a_i,
    b_i,
    c_i,
    d_i,
    sel_i
    );
    
    input a_i;
    input b_i;
    input c_i;
    input d_i;
    input [1:0] sel_i;
    output q_o;
    
    reg q_o;
    
    always @(a_i or b_i or c_i or d_i or sel_i) begin
        case (sel_i)
        2'b00 : q_o = a_i;
        2'b01 : q_o = b_i;
        2'b10 : q_o = c_i;
        2'b11 : q_o = d_i;
        endcase
    end
endmodule 


module lab1_1 (a, b, c, aluctr, d, e);
    input a, b, c;
    input [1:0] aluctr;
    output d, e;

    wire d_a_i, d_tmp0, d_b_i, d_c_i, d_d_i, d_tmp1;
    wire e_a_i, e_tmp0, etmp1, e_tmp2;

    /* output e part */
    // full adder Cout part
    and and2(e_tmp0, a, b);
    and and3(e_tmp1, a, c);
    and and4(e_tmp2, b, c);
    or or1(e_a_i, e_tmp0, e_tmp1, e_tmp2);

    mux4_to_1 mux0(.q_o(e), .a_i(e_a_i), .b_i(0), .c_i(0), .d_i(0), .sel_i(aluctr));

    /* output d part */
    // full adder S part
    myxor xor0(.out(d_tmp0), .a(a), .b(b));
    myxor xor1(.out(d_a_i), .a(d_tmp0), .b(c));

    // a and b
    and and0(d_b_i, a, b);

    // a nor b
    or nor0(d_tmp1, a, b);
    not nor1(d_c_i, d_tmp1);

    // a xor b
    myxor xor2(.out(d_d_i), .a(a), .b(b));

    mux4_to_1 mux1(.q_o(d), .a_i(d_a_i), .b_i(d_b_i), .c_i(d_c_i), .d_i(d_d_i), .sel_i(aluctr));
endmodule
