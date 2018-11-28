//+++++++++++++++++++++++++++++++++++++++++++++++++
// Nested Module
//+++++++++++++++++++++++++++++++++++++++++++++++++
module nested_module();

//=================================================
// Module declration inside the module
//=================================================
module counter(input clk,enable,reset,
output logic [3:0] data);

  always @ (posedge clk)
    if (reset) data <= 0;
    else if (enable) data ++;
endmodule

logic clk = 0;
always #1 clk++;
logic enable, reset;
wire [3:0] data;

counter U(clk,enable,reset,data);

initial begin
  $monitor("@%0dns reset %b enable %b data %b",
     $time,reset,enable,data);
  reset <= 1;
  #10 reset <= 0;
  #1 enable <= 1;
  #10 enable <= 0;
  #4 $finish;
end

endmodule
