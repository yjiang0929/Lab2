module dff
(
input D,
input CE,
input clk,
output reg Q


  );

always @(posedge clk ) begin
  if(CE)
    Q <= D;
end

endmodule
