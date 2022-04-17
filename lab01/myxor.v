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