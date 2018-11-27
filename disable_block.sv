module disable_block ();

initial begin
  fork : FORK
    for (int i = 0 ; i < 9; i ++) begin
      if (1 == 5) begin
        $display ("break first for loop");
        break;
      end
      #1 $display ("First  -> Current value of i = %g", i);
    end
    for (int i = 9 ; i > 0; i --) begin : FOR_LOOP
      if (i == 6) begin
        $display ("Disable FOR_LOOP");
        disable FOR_LOOP;
      end
      #1 $display ("Second -> Current value of i = %g", i);
    end
    for (int i = 0 ; i < 30; i += 2) begin : FOR_LOOP
      if (i == 16) begin
        $display ("Disable FORK");
        disable FORK;
      end
      #1 $display ("third -> Current value of i = %g", i);
    end
  join
  #10 $finish;
end

endmodule
