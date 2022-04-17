`define Initial 3'b000
`define Deposit 3'b001
`define Buy 3'b010
`define Change 3'b011
`define Idle 3'b101
`define BuyDrinkA 3'b110
`define BuyDrinkB 3'b111
`define alpha_S 7'b1010010
`define alpha_O 7'b0011000
`define alpha_D 7'b0100001
`define alpha_A 7'b0100000
`define alpha_T 7'b0000111
`define alpha_E 7'b0000110

module lab05(clk, rst, money_5, money_10, cancel, drink_A, drink_B, drop_money, enough_A, enough_B, DIGIT, DISPLAY);
    input clk;
    input rst;
    input money_5;
    input money_10;
    input cancel;
    input drink_A;
    input drink_B;
    output reg[9:0] drop_money;
    output reg enough_A;
    output reg enough_B;
    output [3:0] DIGIT;
    output [6:0] DISPLAY;

    reg [2:0] state, next_state;
    reg [2:0] buy_state, next_buy_state;
    reg [7:0] price, balance, next_price, next_balance, value;
    reg [3:0] digit;
    reg [6:0] display;
    reg [14:0] num;
    reg [9:0] next_drop_money;
    reg [10:0] cnt, cnt1;

    wire clk_div13, clk_div16, clk_div23, clk_div26, clk_div27;
    wire money_5_debounced, money_10_debounced, money_5_pulse, money_10_pulse;
    wire drink_A_de, drink_B_de, drink_A_pulse, drink_B_pulse, cancel_de, cancel_pulse;
    wire [7:0] p1, p2, b1, b2;

    clock_divider #(13) cd0 (.clk(clk), .clk_div(clk_div13));
    clock_divider #(16) cd1 (.clk(clk), .clk_div(clk_div16));
    clock_divider #(23) cd2 (.clk(clk), .clk_div(clk_div23));
    clock_divider #(26) cd3 (.clk(clk), .clk_div(clk_div26));
    clock_divider #(27) cd4 (.clk(clk), .clk_div(clk_div27));

    debounce de0 (.pb_debounced(money_5_debounced), .pb(money_5), .clk(clk_div16));
    debounce de1 (.pb_debounced(money_10_debounced), .pb(money_10), .clk(clk_div16));
    debounce de2 (.pb_debounced(drink_A_de), .pb(drink_A), .clk(clk_div16));
    debounce de3 (.pb_debounced(drink_B_de), .pb(drink_B), .clk(clk_div16));
    debounce de4 (.pb_debounced(cancel_de), .pb(cancel), .clk(clk_div16));
    
    onepulse op0 (.pb_debounced(money_5_debounced), .clk(clk_div16), .pb_1pulse(money_5_pulse));
    onepulse op1 (.pb_debounced(money_10_debounced), .clk(clk_div16), .pb_1pulse(money_10_pulse));
    onepulse op2 (.pb_debounced(drink_A_de), .clk(clk_div16), .pb_1pulse(drink_A_pulse));
    onepulse op3 (.pb_debounced(drink_B_de), .clk(clk_div16), .pb_1pulse(drink_B_pulse));
    onepulse op4 (.pb_debounced(cancel_de), .clk(clk_div16), .pb_1pulse(cancel_pulse));

    always @(posedge clk_div16) begin
        if (rst == 1) begin
            state = `Initial;
            price = 8'd0;
            balance = 8'd0;
            buy_state = `Idle;
            drop_money = 10'b0;
        end
        else begin
            state = next_state;
            price = next_price;
            balance = next_balance;
            buy_state = next_buy_state;
            drop_money = next_drop_money;
        end
    end

    always @(*) begin
        next_drop_money = 10'b0;
        enough_A = 1'b0;
        enough_B = 1'b0;
        case (state)
            `Initial: begin
                next_state = `Deposit;
                next_buy_state = `Idle;
                next_price = 8'd0;
                next_balance = 8'd0;
            end
            `Deposit: begin
                next_state = `Deposit;
                next_buy_state = `Idle;
                next_balance = balance;
                next_price = price;
                enough_A = (balance >= 20) ? 1'b1 : 1'b0;
                enough_B = (balance >= 25) ? 1'b1 : 1'b0;
                if (money_10_pulse == 1) begin
                    next_balance = (balance >= 8'd90) ? balance : balance + 8'd10; 
                end
                if (money_5_pulse == 1) begin
                    next_balance = (balance >= 8'd95) ? balance : balance + 8'd5;
                end
                if (drink_A_pulse == 1) begin
                    next_price = 8'd20;
                    if (price == 8'd20 && balance >= 8'd20) begin
                        next_buy_state = `BuyDrinkA;
                        next_state = `Buy;
                    end
                end
                if (drink_B_pulse == 1) begin
                    next_price = 8'd25;
                    if (price == 8'd25 && balance >= 8'd25) begin
                        next_buy_state = `BuyDrinkB;
                        next_state = `Buy;
                    end
                end
                if (cancel_pulse == 1 || num > 15'd9000) begin
                    next_price = 8'd0;
                    next_state = `Change;
                    next_buy_state = `Idle;
                end 
            end
            `Buy: begin
                next_state = (cnt == 11'd1024) ? `Change : `Buy;
                next_price = 8'd0;
                next_buy_state = `Idle;
                if (buy_state == `BuyDrinkA) begin
                    next_balance = balance - 8'd20;
                end
                else begin
                    next_balance = balance - 8'd25;
                end 
            end
            `Change: begin
                next_price = 8'd0;
                next_buy_state = `Idle;
                next_state = state;
                next_balance = balance;
                next_drop_money = drop_money;
                if (cnt1 == 11'd1024) begin
                    if (balance >= 10) begin
                        next_balance = balance - 8'd10;
                        next_drop_money = 10'b1111111111;
                        next_state = `Change;
                    end 
                    else if (balance >= 5) begin
                        next_balance = balance - 8'd5;
                        next_drop_money = 10'b1111100000;
                        next_state = `Change;
                    end
                    else begin
                        next_balance = balance;
                        next_state = `Initial;
                    end
                end
            end
        endcase
    end
   
    always @(posedge clk_div13) begin
        case (digit)
            4'b1110: begin
            value = b1;
            digit = 4'b1101;
            end
            4'b1101: begin
            value = p2;
            digit = 4'b1011;
            end
            4'b1011: begin
            value = p1;
            digit = 4'b0111;
            end
            4'b0111: begin
            value = b2;
            digit = 4'b1110;
            end
            default: begin
            value = b2;
            digit = 4'b1110;
            end
        endcase
    end

    always @* begin
        case (value)
            8'd0: display = 7'b1000000;
            8'd1: display = 7'b1111001;
            8'd2: display = 7'b0100100;
            8'd3: display = 7'b0110000;
            8'd4: display = 7'b0011001;
            8'd5: display = 7'b0010010;
            8'd6: display = 7'b0000010;
            8'd7: display = 7'b1111000;
            8'd8: display = 7'b0000000;
            8'd9: display = 7'b0010000;
            8'd10: display = `alpha_A;
            8'd11: display = `alpha_D;
            8'd12: display = `alpha_E;
            8'd13: display = `alpha_S;
            8'd14: display = `alpha_T;
            8'd15: display = `alpha_O;
            default: display = 7'b0010000;
        endcase
    end

    always @(posedge clk_div16) begin
        case(state)
            `Deposit : begin
                if(drink_A_pulse == 1 || drink_B_pulse == 1 
                || money_10_pulse == 1 || money_5_pulse == 1)
                    num = 15'd0;
                else 
                    num = num + 15'd1;
            end
            default:
                num = 15'd0;
        endcase    
    end

    always @(posedge clk_div16) begin
        case(state) 
            `Buy : begin
                cnt<=cnt+11'b1;
            end
            default begin
                cnt<=0;
            end
        endcase
    end

    always @(posedge clk_div16) begin
        case(state) 
            `Change : begin
                if (cnt1 == 11'd1024)
                    cnt1<=0;
                else 
                    cnt1<=cnt1+11'b1;
            end
            default begin
                cnt1<=0;
            end
        endcase
    end

    assign DIGIT = digit;
    assign DISPLAY = display;
    assign p1 = (state == `Buy) ? ((buy_state == `BuyDrinkA) ? 8'd13 : 8'd14) : price / 8'd10;
    assign p2 = (state == `Buy) ? ((buy_state == `BuyDrinkA) ? 8'd15 : 8'd12) : price % 8'd10;
    assign b1 = (state == `Buy) ? ((buy_state == `BuyDrinkA) ? 8'd11 : 8'd10) : balance / 8'd10;
    assign b2 = (state == `Buy) ? ((buy_state == `BuyDrinkA) ? 8'd10 : 8'd10) : balance % 8'd10;

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

module onepulse (pb_debounced, clk, pb_1pulse);
    input pb_debounced;
    input clk;
    output pb_1pulse;
    reg pb_1pulse;
    reg pb_debounced_delay;
    always @(posedge clk) begin
        if (pb_debounced == 1'b1 & pb_debounced_delay == 1'b0)
            pb_1pulse <= 1'b1;
        else
            pb_1pulse <= 1'b0;
        pb_debounced_delay <= pb_debounced;
    end
endmodule

module clock_divider(clk, clk_div);
    parameter n = 26;
    input clk;
    output clk_div;

    reg [n-1:0] num;
    wire [n-1:0] next_num;

    always @(posedge clk) begin
        num = next_num;
    end

    assign next_num = num+1;
    assign clk_div = num[n-1];
endmodule