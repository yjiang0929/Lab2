`timescale 1 ns / 1 ps
`include "spimemory.v"

module finalTest();

reg clk;
wire miso_pin;
wire mosi_pin;
wire sclk;
wire cs;
wire [3:0] sRegOutP;

reg		begintest;	// Set High to begin testing register file
wire  	endtest;    	// Set High to signal test completion
wire		dutpassed;	// Indicates whether register file passed tests

spiMemory dut(.clk(clk),
        .sclk_pin(sclk),
        .cs_pin(cs),
        .miso_pin(miso_pin),
        .mosi_pin(mosi_pin),
        .leds(sRegOutP));

// Instantiate test bench to test the DUT
testbench tester(
   .begintest(begintest),
   .endtest(endtest),
   .dutpassed(dutpassed),
   .clk(clk),
   .sclk(sclk),
   .cs(cs),
   .miso_pin(miso_pin),
   .mosi_pin(mosi_pin),
   .sRegOutP(sRegOutP));


initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

// Test harness asserts 'begintest' for 1000 time steps, starting at time 10
initial begin
  $dumpfile("finalrunner.vcd");
  $dumpvars();
  begintest=0;
  #100;
  begintest=1;
  #50000;
  $finish();
end

// Display test results ('dutpassed' signal) once 'endtest' goes high
always @(posedge endtest) begin
  $display("DUT passed?: %b", dutpassed);
end

endmodule



module testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// spi memory DUT connections
input wire clk,
output wire miso_pin,
output reg mosi_pin,
output reg sclk,
output reg cs,
output wire [3:0] sRegOutP
);

  // Initialize register driver signals
  initial begin
  end
  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #100

    // TODO: test cases go here
    cs = 0;
    // select first register 0000101
    mosi_pin = 0;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0;#100
    sclk = 1; #100
    sclk = 0; #100

    //set first register's value to 11110000
    mosi_pin = 1;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100

    cs = 1;
    // select second register 1010000
    mosi_pin = 1;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0;#100
    sclk = 1; #100
    sclk = 0; #100

    sclk = 1; #100
    sclk = 0; #100

    sclk = 1; #100
    sclk = 0; #100

    sclk = 1; #100
    sclk = 0; #100
    // mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100


    //set second register's value to 10101010
    mosi_pin = 1;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0; #100
    sclk = 1; #100
    sclk = 0; #100

    mosi_pin = 1;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0; #100
    sclk = 1; #100
    sclk = 0; #100

    mosi_pin = 1;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0; #100
    sclk = 1; #100
    sclk = 0; #100

    mosi_pin = 1;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1; #100
    sclk = 1; #100
    sclk = 0; #100

    // select first register 0000101
    mosi_pin = 0;#100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 0;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100
    mosi_pin = 1;#100
    sclk = 1; #100
    sclk = 0; #100

    // Cycle clock to read.
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100
    sclk = 1; #100
    sclk = 0; #100



    // All done!  Wait a moment and signal test completion.
    #5
    endtest = 1;
  end

endmodule
