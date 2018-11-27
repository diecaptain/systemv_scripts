module tasks ();

initial begin
  #1 doInit(4,5);
  #1 doInit(9,6);
  #1 $finish;
end

task doInit (input bit [3:0] count, delay);
  reg [7:0] a;
  if (count > 10) begin
    $display ("@%g Returning from task", $time);
    //return;
  end
  #(delay) $display ("@%g Value passed is %d", $time, count);
endtask

endmodule
