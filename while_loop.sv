module while_loop ();

byte a = 0;

initial begin
  do begin
    $display ("Current value of a = %g", a);
    a ++;
  end while  (a < 10);
  #1 $finish;
end

endmodule
