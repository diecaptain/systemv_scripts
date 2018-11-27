module foreach_loop ();

byte a [10] = '{0,6,7,4,5,66,77,99,22,11};

initial begin
  foreach (a[i]) begin
    $display ("Value of a is %g",a[i]);
  end
  #1 $finish;
end

endmodule
