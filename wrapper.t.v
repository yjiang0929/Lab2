// `timescale 1 ns / 1 ps
`include "wrapper.v"
`define DELAY 10

module testWrapper();

reg clk;
reg buttons;
reg[1:0] switches;
wire[3:0] leds;

lab2_wrapper overallWrapper(clk, switches, buttons, leds);

initial clk=0;
always #10 clk=!clk;

initial begin
  $dumpfile("wrapper.vcd");
  $dumpvars();
  buttons = 0; #200
  switches = 00; #200
  switches[0] = 1; #200
  switches[1] = 1; #200
  switches[1] = 0; #200
  switches[1] = 1; #200
  switches[1] = 0; #200
  switches[0] = 0; #200
  switches[0] = 1; #200
  buttons = 1;

#200 $finish;

end


endmodule
