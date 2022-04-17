

//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent    
// Engineer: Kaitlyn Franz
// 
// Create Date: 01/23/2016 03:44:35 PM
// Design Name: Claw
// Module Name: pmod_step_driver
// Project Name: Claw_game
// Target Devices: Basys3
// Tool Versions: 2015.4
// Description: This is the state machine that drives
// the output to the PmodSTEP. It alternates one of four pins being
// high at a rate set by the clock divider. 
// 
// Dependencies: 
// 
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
`define go_buy1 4'd0
`define back_buy1 4'd1
`define go_buy2 4'd2
`define back_buy2 4'd3
`define go_buy3 4'd4
`define back_buy3 4'd5
`define go_buy4 4'd6
`define back_buy4 4'd7
`define Initial 4'd8
`define wait_buy 4'd9
`define drink1 2'd0
`define drink2 2'd1
`define drink3 2'd2
`define drink4 2'd3


`define LEFT 2'b00
`define MIDDLE 2'b01
`define RIGHT 2'b10

module pmod_step_driver(
    input select,
    input rst,
    input clk,
    input clk_or,
    input [1:0] pos,
    output reg [3:0] signal,
    output enable,
    output reg [1:0] which_drink,
    output reg complete
    );
    
    // local parameters that hold the values of
    // each of the states. This way the states
    // can be referenced by name.
    localparam sig4 = 3'b001;
    localparam sig3 = 3'b011;
    localparam sig2 = 3'b010;
    localparam sig1 = 3'b110;
    localparam sig0 = 3'b000;
    
    // register values to hold the values
    // of the present and next states. 
    reg [2:0] present_state, next_state;
    reg en,next_en;
    reg [1:0] which_drink_next;
    reg dir,next_dir;
    reg [3:0] state,next_state_;
    
    // run when the present state, direction
    // or enable signals change.
    reg [30:0]count, next_count;

    parameter [30:0] step1 = 60'b1111111111111111111111111111110;
    parameter [30:0] step2 = 60'b0101111111111111111000000000000;
    parameter [30:0] step3 = 60'b1001111111111111111111110000000;
    parameter [30:0] step4 = 60'b0001111111000000000000011111110;
    
    assign enable = (state == `wait_buy) ? 1 : 0;
    

    always @(posedge clk_or or posedge rst) begin
        if (rst) begin
            count <= 0;
            en <= 0;
            state <= `Initial;
            dir <= 0;
            which_drink <= 0;
        end
        else begin
            which_drink <= which_drink_next;
            dir <= next_dir;
            count <= next_count;
            en <= next_en;
            state <= next_state_;
        end
    end
    always @(*) begin
        next_count = count;
        next_dir = dir;
        next_state_ = state;
        which_drink_next = which_drink;
        next_en = en;
        complete = 1'b0;
        case(state)
            `Initial: begin
                next_dir = 0;
                next_count = 0;
                next_en = 0;
                if(select == 1) begin
                    if(pos == `LEFT) begin
                        next_state_ = `go_buy1;
                        next_count = 0;
                        which_drink_next = `drink1;
                    end
                    else if(pos == `MIDDLE) begin
                        next_state_ = `go_buy2;
                        next_count = 0;
                        which_drink_next = `drink2;
                    end
                    else begin
                        next_state_ = `go_buy3;
                        next_count = 0;
                        which_drink_next = `drink3;
                    end
                end
                else begin
                    next_state_ = `Initial;
                    next_dir = 0;
                    next_count = 0;
                    next_en = 0;
                end
            end 
            `go_buy1: begin
                if(count < step1) begin
                    next_en = 1;
                    next_count = count + 1;
                    next_dir = 1;
                end
                else begin
                    next_count = 0;
                    next_dir = 0;
                    next_state_ = `wait_buy;
                end
            end
            `back_buy1: begin
                if(count < step1) begin
                    next_en = 1;
                    next_count = count + 1;
                    next_dir = 0;
                end
                else begin
                    next_en = 0;
                    next_count = 0;
                    next_state_ = `Initial;
                    complete = 1'b1;
                end
            end
            `go_buy2: begin
                if(count < step2) begin
                    next_en = 1;
                    next_count = count + 1;
                    next_dir = 1;
                end
                else begin
                    next_count = 0;
                    next_dir = 0;
                    next_state_ = `wait_buy;
                end
            end
            `back_buy2: begin
                if(count < step2) begin
                    next_en = 1;
                    next_count = count + 1;
                    next_dir = 0;
                end
                else begin
                    next_en = 0;
                    next_count = 0;
                    next_state_ = `Initial;
                    complete = 1'b1;
                end
            end
            `go_buy3: begin
                if(count < step3) begin
                    next_en = 1;
                    next_count = count + 1;
                    next_dir = 1;
                end
                else begin
                    next_count = 0;
                    next_dir = 0;
                    next_state_ = `wait_buy;
                end
            end
            `back_buy3: begin
                if(count < step3) begin
                    next_en = 1;
                    next_count = count + 1;
                    next_dir = 0;
                end
                else begin
                    next_en = 0;
                    next_count = 0;
                    next_state_ = `Initial;
                    complete = 1'b1;
                end
            end
            `wait_buy: begin
                if(count < step4) begin
                    next_en = 0;
                    next_count = count + 1;
                    next_dir = dir;
                end
                else begin
                    next_count = 0;
                    next_dir = 0;
                    next_en = 1;
                    if(which_drink == `drink1) 
                        next_state_ = `back_buy1;
                    else if(which_drink == `drink2) 
                        next_state_ = `back_buy2;
                    else if(which_drink == `drink3) 
                        next_state_ = `back_buy3;
                    else
                        next_state_ = `back_buy4;
                end
            end
            default: begin
                next_en = 0;
                next_count = 0;
                next_state_ = `Initial;
            end
        endcase
    end

    // always @(*) begin
    //     case (state)
    //         `back_buy1 : begin
    //             if (count < step1) 
    //                 complete = 1'b0;
    //             else 
    //                 complete = 1'b1;
    //         end 
    //         `back_buy2 : begin
    //             if (count < step2) 
    //                 complete = 1'b0;
    //             else 
    //                 complete = 1'b1;
    //         end
    //         `back_buy3 : begin
    //             if (count < step3) 
    //                 complete = 1'b0;
    //             else 
    //                 complete = 1'b1;
    //         end
    //         default: begin
    //             complete = 1'b0;
    //         end
    //     endcase
    // end

    always @ (*)
    begin
        // Based on the present state
        // do something.
        case(present_state)
        // If the state is sig4, the state where
        // the fourth signal is held high. 
        sig4:
            begin
                // If direction is 0 and enable is high
                // the next state is sig3. If direction
                // is high and enable is high
                // next state is sig1. If enable is low
                // next state is sig0.
                if (dir == 1'b0 && en == 1'b1)
                    next_state = sig3;
                else if (dir == 1'b1 && en == 1'b1)
                    next_state = sig1;
                else 
                    next_state = sig0;
            end  
        sig3:
            begin
                // If direction is 0 and enable is high
                // the next state is sig2. If direction
                // is high and enable is high
                // next state is sig4. If enable is low
                // next state is sig0.
                if (dir == 1'b0&& en == 1'b1)
                    next_state = sig2;
                else if (dir == 1'b1 && en == 1'b1)
                    next_state = sig4;
                else 
                    next_state = sig0;
            end 
        sig2:
            begin
                // If direction is 0 and enable is high
                // the next state is sig1. If direction
                // is high and enable is high
                // next state is sig3. If enable is low
                // next state is sig0.
                if (dir == 1'b0&& en == 1'b1)
                    next_state = sig1;
                else if (dir == 1'b1 && en == 1'b1)
                    next_state = sig3;
                else 
                    next_state = sig0;
            end 
        sig1:
            begin
                // If direction is 0 and enable is high
                // the next state is sig4. If direction
                // is high and enable is high
                // next state is sig2. If enable is low
                // next state is sig0.
                if (dir == 1'b0&& en == 1'b1)
                    next_state = sig4;
                else if (dir == 1'b1 && en == 1'b1)
                    next_state = sig2;
                else 
                    next_state = sig0;
            end
        sig0:
            begin
                // If enable is high
                // the next state is sig1. 
                // If enable is low
                // next state is sig0.
                if (en == 1'b1)
                    next_state = sig1;
                else 
                    next_state = sig0;
            end
        default:
            next_state = sig0; 
        endcase
    end 
    
    // State register that passes the next
    // state value to the present state 
    // on the positive edge of clock
    // or reset. 
    always @ (posedge clk, posedge rst)
    begin
        if (rst == 1'b1)
            present_state = sig0;
        else 
            present_state = next_state;
    end
    
    // Output Logic
    // Depending on the state
    // output signal has a different
    // value.     
    always @ (posedge clk)
    begin
        if (present_state == sig4)
            signal = 4'b1100;
        else if (present_state == sig3)
            signal = 4'b0110;
        else if (present_state == sig2)
            signal = 4'b0011;
        else if (present_state == sig1)
            signal = 4'b1001;
        else
            signal = 4'b0000;
    end
endmodule
