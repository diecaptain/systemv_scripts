module sequence_wait ();

reg a, b, c, d, e;
reg clk = 0;

sequence abc;
  @(posedge clk) a ##1 b ##1 c;
endsequence

sequence de;
  @(negedge clk) d ##[2:5] e;
endsequence

initial begin
  forever begin
    wait (abc.triggered || de.triggered);
    if (abc.triggered) begin
      $display( "@%g abc succeeded", $time );
    end
    if (de.triggered) begin
      $display( "@%g de succeeded", $time );
    end
    #2;
  end
end

// Testbench code
initial begin
  $monitor("@%g clk %b a %b b %b c %b d %b e %b", $time, clk, a, b, c, d, e);
  repeat (2) begin
    #2 a = 1;
    d = 1;
    #2 b = 1;
    e = 1;
    #2 c = 1;
    #2 a = 0;
    b = 0;
    c = 0;
    e = 0;
  end
  #2 $finish;
end

always #1 clk = ~clk;

endmodule
