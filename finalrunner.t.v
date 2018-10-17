`timescale 1 ns / 1 ps
`include "spimemory.v"

module finalTest();

reg clk;
reg miso_pin;
reg mosi_pin;
reg sclk;
reg cs;
reg [3:0] sRegOutP;

spiMemory dut(.clk(clk),
        .sclk(sclk),
        .cs(cs),
        .miso_pin(miso_pin),
        .mosi_pin(mosi_pin),
        .sRegOutP(sRegOutP));


initial clk=0;
always #10 clk=!clk;    // 50MHz Clock


initial pin=0;
initial begin
// Be sure to test each of the three conditioner functions:
// Synchronization, Debouncing, Edge Detection
$dumpfile("finalrunner.vcd");
$dumpvars();

$finish();
end

endmodule
