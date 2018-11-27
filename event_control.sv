module event_control ();

reg clk = 0;
reg rst, d, enable, q, latch;


always @ (*)
if (enable) begin
   latch <= d;
end

//always @ (posedge clk iff rst == 0 or posedge rst)
always @ (posedge clk or posedge rst)
if (rst) begin
  q <= 0;
  $display ("Reset is asserted with iff");
end else begin
  q <= d;
end

always @ (posedge clk or posedge rst)
if (rst) begin
  $display ("Reset is asserted, no iff");
end

always #1 clk = ~clk;


initial begin
 $monitor ("@%g clk %b rst %b enable %b d %b q %b latch %b",
            $time, clk, rst, enable, d, q, latch);
 rst = 0;
 #1 d = 0;
 #1 rst = 1;
 #4 rst = 0;
 #1 enable = 1;
 #1 d = 1;
 #10 d = 0;
 #5 $finish;
end

endmodule
