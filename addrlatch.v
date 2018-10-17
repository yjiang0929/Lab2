
module addrlatch(
  input [7:0] D,
  input CE,
  input clk,
  output reg[7:0] Q


  );

  always @(posedge clk ) begin
    if(CE)
      Q <= D;
  end

  endmodule
