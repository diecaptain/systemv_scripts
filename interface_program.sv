//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface mem_if (
  input  wire         clk,
  output logic        reset,
  output logic        enable,
  input  wire [3:0]   count
);
endinterface
//+++++++++++++++++++++++++++++++++++++++++++++++++
// Simple Program with ports
//+++++++++++++++++++++++++++++++++++++++++++++++++
program if_program(mem_if mem);
  //=================================================
  // Initial block inside program block
  //=================================================
  initial begin
    $monitor("@%0dns count = %0d",$time,mem.count);
    mem.reset = 1;
    mem.enable = 0;
    #20 mem.reset = 0;
    @ (posedge mem.clk);
    mem.enable = 1;
    repeat (5) @ (posedge mem.clk);
    mem.enable = 0;
  end
endprogram
//=================================================
//  Module which instanciates program block
//=================================================
module interface_program();
logic clk  = 0;
always #1 clk ++;
logic [3:0] count;
wire reset,enable;
//=================================================
// Connect the interface
//=================================================
mem_if inf(
 .clk    (clk)   ,
 .reset  (reset) ,
 .enable (enable),
 .count  (count)
);
//=================================================
// Simple up counter
//=================================================
always @ (posedge clk)
 if (reset) count <= 0;
 else if (enable) count ++;
//=================================================
// Program is connected like a module
//=================================================
if_program prg_simple(
.mem    (inf)
);
endmodule
