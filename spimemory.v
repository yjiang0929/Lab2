`timescale 1 ns / 1 ps

`include "addrlatch.v"
`include "datamemory.v"
`include "dff.v"
`include "inputconditioner.v"
`include "shiftregister.v"
`include "fsm.v"

//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);



    wire condCS;
    wire condMOSI, condSCLK, posCS, posMOSI, pcoss1, negCS, negMOSI, negSCLK;
    wire serialout;
    wire MISO_BUFF, DM_WE, ADDR_WE, SR_WE;
    wire[7:0] sRegOutP, dataOut, addrOut;
    wire[6:0] address;
    wire Q;

    // Memory for stored operands (parametric width set to 4 bits)
    inputconditioner butt0cond(clk, cs_pin, condCS, posCS, negCS);
    inputconditioner MOSIcond(clk, mosi_pin, condMOSI, posMOSI, negMOSI);
    inputconditioner SCLKcond(clk, sclk_pin, condSCLK, posSCLK, negSCLK);

    fsm fsm0(posSCLK, condCS, sRegOutP[0], MISO_BUFF, DM_WE, ADDR_WE, SR_WE);

    datamemory dm0(clk, dataOut, address, DM_WE, sRegOutP);

    addrlatch addrlatch0(sRegOutP, ADDR_WE, clk, address[6:0]);

    // address <= addrOut[6:0];

    shiftregister register(clk, posSCLK, SR_WE, dataOut, condMOSI, sRegOutP, serialout);

    dff dff0(serialout, negSCLK, clk, Q);

    assign miso_pin = MISO_BUFF? Q : 'bz; //Buffer

endmodule
