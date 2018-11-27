module func_intro ();

bit a ;

initial begin
  #1 a = doInit(4,5);
  #1 a = doInit(9,6);
  #1 void'(doInit(14,15));
  #1 void'(doInit(19,16));
  #1 $finish;
end

function bit unsigned doInit (bit [3:0] count, add);
  reg [7:0] b;
  if (count > 15) begin
    $display ("@%g Returning from function", $time);
    return 0;
  end
  b = add;
  $display ("@%g Value passed is %d", $time, count + b);
  doInit = 1;
endfunction

endmodule
