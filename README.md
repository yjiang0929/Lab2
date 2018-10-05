# CompArch Lab 2: SPI Memory

In this lab you will create an [SPI](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus) Memory and instantiate it on FPGA.  You will also create an automated test harness and use it to verify your memory.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-arch.png" width=300 alt="System Diagram">

You will work in groups of ~3. You may shuffle teams from previous labs if you so choose.

## Work Plan ##

Draft a work plan for this lab.  Break down the lab in to small portions, and for each portion predict how long it will take (in hours) and when it will be done by (date). Use your work plan reflection from Lab 1 to help with this task. 

Submit this plan by pushing `work_plan.txt` to GitHub and submitting a link on Canvas. Markdown/PDF format also OK.

## Input Conditioning ##

The Input Conditioning subcircuit serves three purposes:

1. **Input Synchronization**:  The pair of D flip-flops at the front of this unit synchronize the external signal to the internal clock domain. The setup and hold requirements of the first flip-flop will likely be violated – its input can occur at any phase offset with respect to the internal oscillator.  The second flip-flop takes the partially synchronized signal and brings it fully into phase with the internal domain.

1. **Input Debouncing**:  Buttons and Switches are notoriously noisy, and may be unstable for several milliseconds after a transition due to mechanical oscillations.  Purely electrical signal sources may also show similar (but much less severe) oscillations due to noise and signal reflections.  This circuit cleans up that oscillation by waiting for it to stabilize. 

1. **Edge Detection**: The `positiveedge` and `negativeedge` output signals are asserted for a single clock cycle on each positive and negative edge of the external signal.  These are used by other subcircuits to emulate `@(posedge ___)` type behaviors without creating extra clock domains.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-glitch.png" width=500 alt="Glitch Suppression and Edge Detection">

_Glitch Suppression and Edge Detection_

Start with the behavioral Verilog module provided in `inputconditioner.v`.

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-ic-box.png" width=300 alt="Input conditioner box diagram">

Modify the module so that the `positiveedge` and `negativeedge` output signals are correctly generated. These signals should be high for exactly one clock period when `conditioned` has a positive/negative edge, starting in the same clock period that `conditioned` transitions.

Note: There are several possible ways to generate the edge signals. Remember that `assign` statements are continuous and operate on `wire`s, while assignments in `always` blocks (e.g. nonblocking `<=`) operate on `reg`s.

### Input Conditioner Deliverables ###
 - Complete module in `inputconditioner.v` 
 - Your test bench `inputconditioner.t.v` demonstrates the three input conditioner functions (i.e. synchronization, debouncing, edge detection)
 - Test script that executes the test bench and generates wave forms showing the correct operation of your input conditioner. Include images of these waveform(s) in your final report.
 - In your final report, include a circuit diagram of the structural circuit for the input conditioner. This should be drawn from primitives such as D flip-flops, adders, muxes, and basic gates.
 - If the main system clock is running at 50MHz, what is the maximum length input glitch that will be suppressed by this design for a `waittime` of 10?  Include the analysis in your report.

## Shift Register ##
Create a shift register supporting both "Serial In, Parallel Out" and "Parallel In, Serial Out" modes of operation.   It should have the following module definition:

```verilog
module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);
```

The shift register is clocked by the main system oscillator `clk` running at 50MHz.  All behaviors are synchronous to this clock:

1. When the peripheral clock `peripheralClkEdge` has an edge, the shift register advances one position: `serialDataIn` is loaded into the LSB (Least Significant Bit), and the rest of the bits shift up by one.  This uses the Input Conditioner's edge detection capabilities.
1.  When `parallelLoad` is asserted, the shift register will take the value of `parallelDataIn`.
1. `serialDataOut` always presents the Most Significant Bit of the shift register.
1. `parallelDataOut` always presents the entirety of the contents of the shift register.

Each of these four behaviors can be implemented in one or two lines of behavioral Verilog.  You may want to look at Verilog's `{}` concatenate syntax for implementing the serial behavior.

It is good design practice to decide which behavior will "win" if a parallel load and a serial shift happen in the same clock edge.  Otherwise the synthesizer will make that decision for you (likely without a warning).

### Shift Register Deliverables ###
 - Complete module in `shiftregister.v`
 - Your test bench in `shiftregister.t.v` demonstrating both modes of operation for the shift register.
 - In your final report, you should describe your test bench strategy.


## Midpoint Check In ##

Create a top-level module with the following structure and load it onto the FPGA:

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-mid.png" width=500 alt="Midpoint Check In Structure">

The parallel data input of the shift register is tied to a constant value, and the load is triggered when button 0 is pressed.

Switches 0 and 1 allow manual control of the serial input.

LEDs show the state of the shift register (note: you only have 4 to work with, so you will have to show a subset of bits, use the Lab 0 trick, or borrow an external LED board)

### Loading to FPGA ###
Load the shift register and the input conditioners onto the Zybo board, following the same procedure as for Lab0.

### Midpoint Deliverables ###

Push the module described above to GitHub as `midpoint.v`. Because testing will be done by hand, no Verilog test bench is required for this file.

Design a test sequence that demonstrates successful operation of this portion of the lab.  Provide a short written description of what the test engineer is to do, and what the state of the LEDs should be at each step.

Demonstrate your test to course staff, or record a short video/gif of the execution and submit the link (please don't push huge videos to GitHub.


## SPI Memory ##

You now have everything you need to create a complete SPI memory. We will make it 128 bytes in size. It will have the following module definition:

```verilog
module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
)
```

The `SCLK`, `CS`, `MISO`, and `MOSI` signals obey the SPI standard. The LED outputs are in case you need debugging information.

### Behavior ###

Each transaction begins with the Chip Select `CS` line being asserted `low`.  Whenever `CS` is `high`, the memory ignores all other inputs, tri-states `MISO`, and resets any communication state machines.  

Next, 8 bits are clocked in by the Master.  The first 7 bits are the memory address, Most Significant Bit first.  The 8th bit is the `R/~W` flag: Read when high, Write when low.

For a `Write` operation, the master will then clock in 8 bits of data and de-assert `CS`.

For a `Read` operation, the slave will assert `MISO` and clock out the data found at `address`.

Data is always presented on the falling edge, and always read on the rising edge of `SCLK`.

#### Write operation ####

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-write.png" alt="Write operation timing diagram">

#### Read operation ####

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-read.png" alt="Read operation timing diagram">

### Schematic ###

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/lab2-spi-schem.png" alt="SPI memory schematic">

This is one possible schematic for the SPI Memory. If it doesn't make sense to you based on how you think about designing the system, please discard it entirely. You may implement your design however you prefer, as long as it meets the specification shown in the waveforms above. The Serial Out pin is synchronized to the falling edge of `SCLK` to obey the standard we are using (Data is presented on the falling edge, and captured on the rising edge).  

### Finite State Machine ###

The schematic above uses a finite state machine to provide the appropriate control signals at the right times, and you will likely want to do the same. Begin by drawing the states and transitions of your controller during both read and write operations on paper. Next construct a table describing what all the control signals should be in each state, and then implement and test your FSM. Include your FSM diagram and control table in the final report. We **strongly** suggest that you show your paper design to an instructor to get feedback before getting too deep into implementation.


## SPI Memory Testing ##


### Test Strategy ###
Your final report should include a detailed analysis of your testing strategy.  Why did you choose the test sequences you did?  

### External testing (optional) ###

One option for testing your memory is to connect to external hardware by routing your SPI port to the pins of the FPGA, so it can be accessed by an external device (such as an Arduino). You can also do the same on the Zybo board by using the internal processor.


## Final submission ##

Compile a report (PDF or Markdown) with all the information requested above, plus a short reflection/analysis of your work plan compared to reality. Push the report along with all your Verilog modules, testbenches, and scripts to GitHub, and submit a link on Canvas.


## Notes/Hints ##

### Input Conditioning ###

You may need to adjust your deglitching wait period differently for when it is driven by switches vs when it is driven by the tester.  Switches are much noisier.

### Autograde Etiquette ##

The autograder will compile all Verilog files that are in your repository.  This means that things like `InputConditioner_OLD.v` may cause naming conflicts if they have the same modules inside.  Make sure that you do not have multiple modules with the same name.


### FPGA Synthesis Preparation ###

Make sure that each of your always blocks' sensitivity lists are only `always @(posedge clk)`.  Other sensitivity lists may cause clock gating.

The Xilinx synthesizer obeys the `initial` block syntax with varying degrees of success.  To initialize a register, do so in its declaration: `reg regname = 0;`. This technique does not work with 2 dimensional arrays.

### FSM Debugging ###
Icarus doesn’t have enumeration support.  To make your debugging life a little easier, you can define your state machine states with parameters. Using parameters local to the module that uses the states keeps your name space a little cleaner.

```verilog
parameter state_GETTING_ADDRESS 	= 0;
parameter state_GOT_ADDRESS 	    = 1;
parameter state_READ_1 		        = 2;
parameter state_READ_2	 	        = 3;
```

You can also use translate filters in GTKWave to translate from the signal values back into meaningful names. For example, say you have the following trace:

<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/gtkwave_numbers.JPG" alt="Default GTKWave trace">

If you write a filter file like the one below, you can highlight the signals of interest and select `Data Format > Translate Filter File` to show the human-readable aliases instead.

```
# Example filter file
#   Each line has a value (which much match what is in the wave viewer exactly) and a string alias to replace the value if found
00 Zero
01 First
03 Third
```
<img src="https://e38023e2-a-62cb3a1a-s-sites.googlegroups.com/site/ca15fall/resources/gtkwave_names.JPG" alt="GTKWave trace with aliases">

More information about GTKWave filtering can be found in the [GTKWave User's Guide (PDF)](http://gtkwave.sourceforge.net/gtkwave.pdf). 

You will need to keep the parameters and filter file synchronized by hand.
