//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`include "addrlatch.v"
`include "datamemory.v"
`include "dff.v"
`include "inputconditioner.v"
`include "shiftregister.v"
`include "fsm.v"

module spiMemo
(
    input        clk,
    input     SCLK, // sw0 = MOSI; sw1 = SCLK;
    input  CS,     // btn = ;
    output miso_pin,
    input mosi_pin,
    output [7:0] sRegOutP
)


    wire condCS, condMOSI, condSCLK, posCS, posMOSI, pcoss1, negCS, negMOSI, negSCLK;
    wire serialout;
    wire MISO_BUFF, DM_WE, ADDR_WE, SR_WE;
    wire[7:0] dataOut, addrOut;
    wire[6:0] address;
    wire Q;

    // Memory for stored operands (parametric width set to 4 bits)
    inputconditioner butt0cond(clk, CS, condCS, posCS, negCS);
    inputconditioner MOSIcond(clk, MOSI, condMOSI, posMOSI, negMOSI);
    inputconditioner SCLKcond(clk, SCLK, condSCLK, posSCLK, negSCLK);

    fsm fsm0(posSCLK, condCS, sRegOutP[0], MISO_BUFF, DM_WE, ADDR_WE, SR_WE);

    datamemory dm0(clk, dataOut, address, DM_WE, sRegOutP);

    addrlatch addrlatch0(sRegOutP, ADDR_WE, clk, addrOut);

    address <= addrOut[6:0];

    shiftregister register(clk, posSCLK, SR_WE, dataOut, condMOSI, sRegOutP, serialout);

    dff dff0(serialout, negSCLK, clk, Q);

    assign miso_pin = MISO_BUFF? serialout : 'bz; //Buffer

endmodule

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
)


endmodule
