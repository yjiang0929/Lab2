//-----------------------------------------------------------------------------
//  Wrapper for Lab 2
//
//  Rationale:
//     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs.
//
//     This wrapper module allows for 4-bit operands to be loaded in one at a
//     time, and multiplexes the LEDs to show the SUM and carryout/overflow at
//     different times.
//
//  Your job:
//     Write FullAdder4bit with the proper port signature. It will be instantiated
//     by the lab0_wrapper module in this file, which interfaces with the buttons,
//     switches, and LEDs for you.
//
//  Usage:
//     btn0 - load operand A from the current switch configuration
//     btn1 - load operand B from the current switch configuration
//     btn2 - show SUM on LEDs
//     btn3 - show carryout on led0, overflow on led1
//
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     on the right.
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

`include "inputconditioner.v"
`include "shiftregister.v"
`define WIDTH 8




//-----------------------------------------------------------------------------
// Main Lab 0 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//
//   You must write the FullAdder4bit (in your adder.v) to complete this module.
//   Challenge: write your own interface module instead of using this one.
//------- ----------------------------------------------------------------------
`define xA5 32'h0000000
`define xB5 32'hFFFFFFF
module lab2_wrapper
(
    input        clk,
    input  [3:0] sw,
    input  [3:0] btn,
    output [3:0] led
);


    reg condb0, conds0, conds1, posb0, poss0, poss1, negb0, negs0, negs1;
    wire serialout;
    wire[WIDTH-1:0] parallelOut;

    // Memory for stored operands (parametric width set to 4 bits)
    inputconditioner butt0cond(clk, btn[0], condb0, posb0, negb0);
    inputconditioner sw0cond(clk, sw[0], conds0, poss0, negs0);
    inputconditioner sw1cond(clk, sw[1], conds1, poss1, negs1);

    shiftregister register(clk, poss1, negb0, xA5, conds0, parallelOut, serialout);

    led[3:0] = parallelOut[3:0];


endmodule
