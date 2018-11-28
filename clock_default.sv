module clock_default();

logic        clk = 0;
always #10 clk++;

// Specify the default clocking
default clocking test @ (posedge clk);

endclocking

initial begin
  $display("%0dns is current time",$time);
  // Any ## is evaluated with respect to default clock
  ##100;
  $display("%0dns is current time",$time);
  $finish;
end

endmodule
