module for_loop ();

initial begin
  fork
    for (int i = 0 ; i < 4; i ++) begin
      #1 $display ("First  -> Current value of i = %g", i);
    end
    for (int i = 4 ; i > 0; i --) begin
      #1 $display ("Second -> Current value of i = %g", i);
    end
  join
  #1 $finish;
end

endmodule
