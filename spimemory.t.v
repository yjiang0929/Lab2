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

// Test harness asserts 'begintest' for 5000 time steps, starting at time 10
initial begin
  $dumpfile("spimemory.vcd");
  $dumpvars();
  begintest=0;
  // #500;
  begintest=1;
  #500000;
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
    sclk = 0;
    dutpassed = 1;

    // TODO: test cases go here
    cs = 1;
    // sclk pulse to signify start
    sclk = 0; #500
    sclk = 1; #500
    if(dut.fsm0.state != 5'b00000) begin
			$displayb("Test failed: there should be no state at this time, but the state is actually %b.", dut.fsm0.state);
      dutpassed = 0;
		end
    sclk = 0;



    cs = 0;


    // select first register 0000100
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    if(dut.fsm0.state != 5'b00001) begin
			$displayb("Test failed: we should be in the getting address state, but the state is actually %b.", dut.fsm0.state);
      dutpassed = 0;
		end
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 1;
    sclk = 0; #500
    sclk = 1; #500
    // mosi_pin = 1;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0; //write
    sclk = 0; #500
    sclk = 1; #500
    if(dut.dm0.address != 7'b0000100) begin
      $displayb("Test failed: dut address is %b but should be 0000100", dut.dm0.address);
      dutpassed = 0;
    end

    //set first register's value to 11110000
    mosi_pin = 1;
    if(dut.fsm0.state != 5'b01010) begin
			$displayb("Test failed: we should be in the address obtained state, but the state is actually %b.", dut.fsm0.state);
      dutpassed = 0;
		end
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    if(dut.dm0.memory[7'b0000100] != 8'b11110000) begin
			$displayb("Test failed: register %b should be value 11110000 but is actually %b.", 7'b0000100, dut.dm0.memory[7'b0000100]);
      dutpassed = 0;
		end

    //Pause between tests.
    cs = 1; #5000
    if(dut.fsm0.state != 5'b00000) begin
      $displayb("Test failed: we should be idle, but the state is actually %b.", dut.fsm0.state);
      dutpassed = 0;
    end
    cs=0;
    // select first register 0000100
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 1;
    sclk = 0; #500
    sclk = 1; #500
    // mosi_pin = 1;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 1; //read
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;

    // read from 0000100

    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][7]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if(dut.fsm0.state != 5'b10110) begin
			$displayb("Test failed: we should be in the sendinig data to master state, but the state is actually %b.", dut.fsm0.state);
      dutpassed = 0;
		end
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][6]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][5]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][4]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][3]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][2]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][1]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][0]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500

    cs = 1; #5000

    cs = 0;

    // select first register 0000100
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 1;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0; //write
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;

    // Start writing 00000000
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    //get interrupted
    cs = 1;
    if(dut.dm0.memory[7'b0000100] != 8'b11110000) begin
			$displayb("Test failed after stopping reading: register %b should be value 11110000 but is actually %b.", 7'b0000100, dut.dm0.memory[7'b0000100]);
      dutpassed = 0;
		end

    cs = 0; #5000
    // select first register 0000100
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 1;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 1; //write
    sclk = 0; #500
    sclk = 1; #500
    mosi_pin = 0;

    //Start writing

    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][7]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500

    cs = 1; # 500

    if(dut.dm0.memory[7'b0000100] != 8'b11110000) begin
			$displayb("Test failed after stopping writing: register %b should be value 11110000 but is actually %b.", 7'b0000100, dut.dm0.memory[7'b0000100]);
      dutpassed = 0;
		end


    //Double checking we can still read successfully from register 0000100
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][7]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][6]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][5]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 1) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][4]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][3]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][2]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][1]);
      dutpassed = 0;
    end
    sclk = 0; #500
    sclk = 1; #500
    if (miso_pin != 0) begin
			$display("Test failed: shift register output does not match the memory at the correspondong address. miso_pin: %b, memory: %b", miso_pin, dut.dm0.memory[7'b0000100][0]);
      dutpassed = 0;
    end

    cs = 1; #5000


    // Second register tests.

    sclk = 0; #500
    sclk = 1; #500

    // select second register 1050000
    mosi_pin = 1;#500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0;#500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 1;#500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0;#500
    sclk = 1; #500
    sclk = 0; #500

    sclk = 1; #500
    sclk = 0; #500

    sclk = 1; #500
    sclk = 0; #500

    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0;#500 //Write
    sclk = 1; #500
    sclk = 0; #500


    //set second register's value to 10101010
    mosi_pin = 1;#500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0; #500
    sclk = 1; #500
    sclk = 0; #500

    mosi_pin = 1;#500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0; #500
    sclk = 1; #500
    sclk = 0; #500

    mosi_pin = 1;#500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0; #500
    sclk = 1; #500
    sclk = 0; #500

    mosi_pin = 1;#500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 1; #500
    sclk = 1; #500
    sclk = 0; #500

    // select first register 0000101
    mosi_pin = 0;#500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 1;#500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 0;#500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 1;#500
    sclk = 1; #500
    sclk = 0; #500
    mosi_pin = 1;#500 //read
    sclk = 1; #500
    sclk = 0; #500

    // Cycle clock to read.
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500
    sclk = 1; #500
    sclk = 0; #500



    // All done!  Wait a moment and signal test completion.
    #5
    endtest = 1;
  end

endmodule
