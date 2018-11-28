//+++++++++++++++++++++++++++++++++++++++++++++++++
//   DUT With assertions
//+++++++++++++++++++++++++++++++++++++++++++++++++
module assert_concurrent(
  input wire clk,req,reset,
  output reg gnt);
//=================================================
// Sequence Layer
//=================================================
sequence req_gnt_seq;
  // (~req & gnt) and (~req & ~gnt) is Boolean Layer
  (~req & gnt) ##1 (~req & ~gnt);
endsequence
//=================================================
// Property Specification Layer
//=================================================
property req_gnt_prop;
  @ (posedge clk)
    disable iff (reset)
      req |-> req_gnt_seq;
endproperty
//=================================================
// Assertion Directive Layer
//=================================================
req_gnt_assert : assert property (req_gnt_prop)
                 else
                 $display("@%0dns Assertion Failed", $time);
//=================================================
// Actual DUT RTL
//=================================================
always @ (posedge clk)
  gnt <= req;

endmodule
