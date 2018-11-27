module fork_join();

task automatic print_value;
  input [7:0] value;
  input [7:0] delay;
  begin
    #(delay) $display("@%g Passed Value %d Delay %d",
      $time, value, delay);
  end
endtask

initial begin
  fork
    #1 print_value (10,7);
    #1 print_value (8,5);
    #1 print_value (4,2);
  join
  $display("@%g Came out of fork-join", $time);
  #5
  fork
    #1 print_value (10,17);
    #1 print_value (8,15);
    #1 print_value (4,12);
  join_any
$display("@%g Came out of fork-join_any", $time);
  #5
  fork
    #1 print_value (10,27);
    #1 print_value (8,25);
    #1 print_value (4,22);
  join_none
$display("@%g Came out of fork-join_none", $time);
// Wait till all the forks (threads are completed their execution)
wait fork;
$display("@%g All threads completed execution", $time);

// terminate all the theads
disable fork;
$display("@%g All threads are disabled", $time);

  #30 $finish;
end

endmodule
