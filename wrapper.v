//-----------------------------------------------------------------------------
//  Wrapper for Lab 2
//
//
//-----------------------------------------------------------------------------

// `timescale 1 ns / 1 ps

`include "inputconditioner.v"
`include "shiftregister.v"
`define WIDTH 8
`define xA5 32'h0000000
`define xB5 32'hFFFFFFF
module lab2_wrapper
(
    input        clk,
    input  [1:0] sw,
    input  btn,
    output [3:0] led
);


    wire condb0, conds0, conds1, posb0, poss0, poss1, negb0, negs0, negs1;
    wire serialout;
    wire[`WIDTH-1:0] parallelOut;
    wire[7:0] test;

    // condb0 <= 0;
    // conds0 <= 0;
    // conds1 <= 0;
    // posb0 <= 0;
    // poss0 <= 0;
    // poss1 <= 0;
    // negb0 <= 0;
    // negs0 <= 0;
    // negs1 <= 0;

    // Memory for stored operands (parametric width set to 4 bits)
    inputconditioner butt0cond(clk, btn, condb0, posb0, negb0);
    inputconditioner sw0cond(clk, sw[0], conds0, poss0, negs0);
    inputconditioner sw1cond(clk, sw[1], conds1, poss1, negs1);

    shiftregister register(clk, poss1, negb0, 8'h00, conds0, test, serialout);

    // led[3:0] <= {test[3:0]};


endmodule
