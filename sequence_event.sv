module sequence_event ();

reg a, b, c;
reg clk = 0;

sequence abc;
  @(posedge clk) a ##1 b ##1 c;
endsequence

always @ (posedge clk)
begin
 @ (abc) $display ("@%g ABC all are asserted", $time);
end

// Testbench code
initial begin
  $monitor("@%g clk %b a %b b %b c %b", $time, clk, a, b, c);
  repeat (2) begin
    #2 a = 1;
    #2 b = 1;
    #2 c = 1;
    #2 a = 0;
    b = 0;
    c = 0;
  end
  #2 $finish;
end

always #1 clk = ~clk;

endmodule
