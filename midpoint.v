`timescale 1 ns / 1 ps

`include "inputconditioner.v"
`include "shiftregister.v"
//--------------------------------------------------------------------------------
// Basic building block modules
//--------------------------------------------------------------------------------

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule

module midpoint
(
    input        clk,
    input  sw0, sw1,
    input  btn,
    input [7:0] parallelIn,
    output [7:0] full_led
);


    wire condb0, conds0, conds1, posb0, poss0, poss1, negb0, negs0, negs1;
    wire serialout;

    // Memory for stored operands (parametric width set to 4 bits)
    inputconditioner butt0cond(clk, btn, condb0, posb0, negb0);
    inputconditioner sw0cond(clk, sw0, conds0, poss0, negs0);
    inputconditioner sw1cond(clk, sw1, conds1, poss1, negs1);

    shiftregister register(clk, poss1, negb0, parallelIn, conds0, full_led, serialout);


endmodule

//-----------------------------------------------------------------------------
// Main Lab 0 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//
//   You must write the FullAdder4bit (in your adder.v) to complete this module.
//   Challenge: write your own interface module instead of using this one.
//-----------------------------------------------------------------------------

module lab0_wrapper
(
    input        clk,
    input  [1:0] sw,
    input   btn,
    output [3:0] led
);

    wire[7:0] res;
    wire[3:0] res0, res1;     // Output display options
    wire res_sel;             // Select between display options

    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[3]), .k(btn[2]), .q(res_sel));
    mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));

    // TODO: You write this in your adder.v
    parameter pIn = 8'hA5;
    midpoint mid(clk, sw[0], sw[1], btn, pIn, res);

    // Assign bits of second display output to show carry out and overflow
    assign res0[0] = res[0];
    assign res0[1] = res[1];
    assign res0[2] = res[2];
    assign res0[3] = res[3];
    assign res1[0] = res[4];
    assign res1[1] = res[5];
    assign res1[2] = res[6];
    assign res1[3] = res[7];

endmodule
