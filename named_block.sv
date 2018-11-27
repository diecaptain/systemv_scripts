module named_block ();

reg clk = 0;

initial
 FIRST_BLOCK : begin
   $display ("This is first block");
 end

initial begin : SECOND_BLOCK
   $display ("This is second block");
   fork : FORK_BLOCK
     #1 $display ("Inside fork with delay 1");
     #2 $display ("Inside fork with delay 2");
   join_none
   FORK_NONE : fork
     #4 $display ("Inside fork with delay 4");
     #5 $display ("Inside fork with delay 5");
   join_none
   #10 $finish;
end

always begin  : THIRD_BLOCK
 #1 clk = ~clk;
end : THIRD_BLOCK

endmodule
