//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`include "shiftregister.v"

module testshiftregister();

    wire             clk;
    wire             peripheralClkEdge;
    wire             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    wire[7:0]        parallelDataIn;
    wire             serialDataIn; 
    
    reg		begintest;	// Set High to begin testing register file
    wire  	endtest;    	// Set High to signal test completion 
    wire		dutpassed;	// Indicates whether register file passed tests
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut),
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn));
    
    // Instantiate test bench to test the DUT
    testbench tester
    (
       .begintest(begintest),
       .endtest(endtest), 
       .dutpassed(dutpassed),
       .clk(clk), 
       .peripheralClkEdge(peripheralClkEdge),
       .parallelLoad(parallelLoad), 
       .parallelDataOut(parallelDataOut), 
       .serialDataOut(serialDataOut),
       .parallelDataIn(parallelDataIn), 
       .serialDataIn(serialDataIn)
     );
    
    // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
    initial begin
      begintest=0;
      #10;
      begintest=1;
      #1000;
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

// shiftregister DUT connections
output    reg             clk,
output    reg             peripheralClkEdge,
output    reg             parallelLoad,
output    wire[7:0]       parallelDataOut,
output    wire            serialDataOut,
output     reg[7:0]        parallelDataIn,
output     reg             serialDataIn
);

  // Initialize register driver signals
  initial begin
    peripheralClkEdge=0;
    parallelLoad=0;
    parallelDataIn=8'b0;
    serialDataIn=0;
    clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1:
  // test basic parallel load setup with all 0s
  parallelLoad=1;
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  // Verify starts at 0
  if ((parallelDataOut !== 0) || (serialDataOut !== 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 1 Failed");
  end


  // Test Case 2:
  // test basic parallel load setup with a simple case
  parallelDataIn=8'd21;
  parallelLoad=1;
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 21)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 2 Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end
  
  // test 3:
  // test serial read by reading the current value of 21 bit by bit
  parallelLoad=0;
  peripheralClkEdge=1;
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 42) || (serialDataOut !== 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3a Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end
  
  peripheralClkEdge=1;
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 84) || (serialDataOut !== 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3b Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end

  peripheralClkEdge=1;
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 168) || (serialDataOut !== 1)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3c Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end
  
  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 80) || (serialDataOut !== 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3d Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end

  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 160) || (serialDataOut !== 1)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3e Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end

  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 64) || (serialDataOut !== 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3f Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end

  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 128) || (serialDataOut !== 1)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3g Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end

  #5 clk=1; #5 clk=0;	// Generate single clock pulse
  #5 clk=1; #5 clk=0;	// Generate single clock pulse

  if ((parallelDataOut !== 0) || (serialDataOut !== 0)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Test Case 3h Failed");
    $display("%b  |  %b", parallelDataOut, serialDataOut);
  end

  // test 4:
  // test serial write by writing a value one bit at a time.

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end
endmodule