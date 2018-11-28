extern module counter (input clk,enable,reset,
  output logic [3:0] data);

//+++++++++++++++++++++++++++++++++++++++++++++++++
// Extern Module
//+++++++++++++++++++++++++++++++++++++++++++++++++
module extern_counter();

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
