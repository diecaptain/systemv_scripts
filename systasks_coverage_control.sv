module systasks_coverage_control();

reg  clk, reset,enable;

reg [3:0] cnt;

always @ (posedge clk)
  if (reset)
    cnt <= 0;
  else if (enable)
    cnt <= cnt + 1;

initial begin
  // Disable coverage before reset
  $coverage_control(`SV_COV_STOP,`SV_COV_STATEMENT,`SV_COV_HIER,$root);
  clk    <= 0;
  reset  <= 1;
  enable <= 0;
  $monitor("Count %0d",cnt);
  repeat (4) @ (posedge clk);
  reset  <= 0;
  // Enable coverage after reset
  $coverage_control(`SV_COV_START,`SV_COV_STATEMENT,`SV_COV_HIER,$root);
  enable <= 1;
  repeat (4) @ (posedge clk);
  enable <= 0;
  #4 $finish;
end

always #1 clk = ~clk;

endmodule
