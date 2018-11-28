//+++++++++++++++++++++++++++++++++++++++++++++++
//   Testbench Code
//+++++++++++++++++++++++++++++++++++++++++++++++
module tb_assert_explicit_sequence();

reg clk = 0;
reg reset, req = 0;
wire gnt;

always #3 clk ++;

initial begin
  reset <= 1;
  #20 reset <= 0;
  // Make the assertion pass
  #100 @ (posedge clk) req  <= 1;
  @ (posedge clk) req <= 0;
  // Make the assertion fail
  #100 @ (posedge clk) req  <= 1;
  repeat (2) @ (posedge clk);
  req <= 0;
  #10 $finish;
end

assert_explicit_sequence dut (clk,req,reset,gnt);

endmodule
