`timescale 1 ns / 1 ps
`include "spimemory.v"

module finalTest();

reg clk;
wire miso_pin;
reg mosi_pin;
reg sclk;
reg cs;
wire [3:0] sRegOutP;

spiMemory dut(clk,
        sclk,
        cs,
        miso_pin,
        mosi_pin,
        sRegOutP);


initial clk=0;
always #10 clk=!clk;    // 50MHz Clock



initial begin
// Be sure to test each of the three conditioner functions:
// Synchronization, Debouncing, Edge Detection
$dumpfile("finalrunner.vcd");
$dumpvars();
  mosi_pin = 0; sclk = 0; cs = 0; #100



$finish();
end

endmodule
