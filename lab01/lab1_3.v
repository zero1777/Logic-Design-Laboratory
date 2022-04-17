module lab1_3 (a, b, c, aluctr, d, e);
    input a, b, c;
    input [1:0] aluctr;
    output d, e;
    reg d, e;

    always @(*) begin
        case (aluctr)
            2'b00 : {e, d} = a + b + c;  
            2'b01 : begin
                d = a & b;
                e = 1'b0;
            end
            2'b10 : begin
                d = ~(a | b);
                e = 1'b0;
            end
            2'b11 : begin
                d = a ^ b;
                e = 1'b0;
            end
        endcase
    end
endmodule