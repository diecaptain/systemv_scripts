//+++++++++++++++++++++++++++++++++++++++++++++++++
//   DUT With assertions
//+++++++++++++++++++++++++++++++++++++++++++++++++
module buffer(
  input wire clk,req,reset,
  output reg gnt);
//=================================================
// Actual DUT RTL
//=================================================
always @ (posedge clk)
  gnt <= req;

endmodule
