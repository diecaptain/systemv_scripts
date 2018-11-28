//+++++++++++++++++++++++++++++++++++++++++++++++++
//   DUT With assertions
//+++++++++++++++++++++++++++++++++++++++++++++++++
module assert_explicit_sequence(
  input wire clk,req,reset,
  output reg gnt);
//=================================================
// Sequence Layer
// Here clock is specified inside the sequence
//=================================================
sequence req_gnt_seq;
  @ (posedge clk)
  (~req & gnt) ##1 (~req & ~gnt);
endsequence
//=================================================
// Property Specification Layer
// Still requires clock for the property
//=================================================
property req_gnt_prop;
  @ (posedge clk)
    disable iff (reset)
      req |=> req_gnt_seq;
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
