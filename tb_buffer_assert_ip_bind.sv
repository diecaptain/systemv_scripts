//+++++++++++++++++++++++++++++++++++++++++++++++
//   Testbench Code
//+++++++++++++++++++++++++++++++++++++++++++++++
`include "buffer.sv"
`include "assert_ip.sv"
`include "assert_ip_bind.sv"

module tb_buffer_assert_ip_bind();

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
  repeat (5) @ (posedge clk);
  req <= 0;
  #10 $finish;
end

buffer dut (clk,req,reset,gnt);

endmodule
