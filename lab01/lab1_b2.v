module lab1_b1 (a, b, c, aluctr, d, e);
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
                d = 1'b0;
                e = (a < b || (a == b && c == 0)) ? 1'b0 : 1'b1;
            end
            2'b11 : begin
                d = a ^ b;
                e = 1'b0;
            end
        endcase
    end
endmodule

module lab1_b2 (a, b, c, aluctr, d, e);
    input [3:0] a,b;
    input [1:0] aluctr;
    input c;
    output [3:0] d;
    output e;

    wire cout0, cout1, cout2;

    lab1_b1 alu0(a[0], b[0], c, aluctr, d[0], cout0);
    lab1_b1 alu1(a[1], b[1], cout0, aluctr, d[1], cout1);
    lab1_b1 alu2(a[2], b[2], cout1, aluctr, d[2], cout2);
    lab1_b1 alu3(a[3], b[3], cout2, aluctr, d[3], e);    
endmodule