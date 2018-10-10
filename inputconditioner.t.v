//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
`include "inputconditioner.v"

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;

    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial pin=0;
    initial begin
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection
    $dumpfile("inputconditioner.vcd");
    $dumpvars();
    //testing input synchronization
    #100 pin=1;
    #100 pin=0;
    #100 pin=1;
    #100 pin=0;
    #200 pin=1;
    //testing input debouncing
    #5 pin=0;
    #5 pin=1;
    #5 pin=0;
    #5 pin=1;
    #5 pin=0;
    #5 pin=1;
    #200 pin=0;
    #5 pin=1;
    #5 pin=0;
    #5 pin=1;
    #5 pin=0;
    #5 pin=1;
    #5 pin=0;
    //testing edge detection
    #200 pin=1;
    #200 pin=0;
    #200 pin=1;
    #200 pin=0;
    end

endmodule
