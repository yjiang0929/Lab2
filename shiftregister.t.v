//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`include "shiftregister.v"

module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));
    
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
        // Be sure to test each of the three conditioner functions:
        $dumpfile("shiftregister.vcd");
        $dumpvars();
        #5000 parallelDataIn=8'b10101010; serialDataIn=0; peripheralClkEdge=0; parallelLoad=1;
        $display(" %b | %b ", serialDataOut, parallelDataOut);
        #500 parallelDataIn=8'b10101010; serialDataIn=0; peripheralClkEdge=1; parallelLoad=0;
        $display(" %b | %b ", serialDataOut, parallelDataOut);
        #5000 parallelDataIn=8'b10101010; serialDataIn=0; peripheralClkEdge=1; parallelLoad=0;
        $display(" %b | %b ", serialDataOut, parallelDataOut);
        #5000 parallelDataIn=8'b10101010; serialDataIn=0; peripheralClkEdge=0; parallelLoad=1;
        $display(" %b | %b ", serialDataOut, parallelDataOut);
    end

endmodule

