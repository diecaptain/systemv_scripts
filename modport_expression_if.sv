//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface arb_if #(num_agents = 1) (input clk);
  logic   reset;
  logic  [num_agents-1 : 0] req;
  logic  [num_agents-1 : 0] gnt;
  //=================================================
  // Modport inside a generate block
  //=================================================
  for (genvar i=0; i< num_agents; i++) begin: arb"%d, i"
     modport arb (input .creq (req[i], clk, reset, output .cgnt (gnt[i]) );
     modport tb (output .creq (req[i], input clk, reset, .cgnt (gnt[i]) );
  end

endinterface

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Testbench Top file
//+++++++++++++++++++++++++++++++++++++++++++++++++
module modport_expression_if();

 logic clk = 0;
 always #1 clk ++;

 arb_if arbif(clk);

initial begin
 #100 $finish;
end

endmodule
