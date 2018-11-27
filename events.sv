module events();
// Declare a new event called ack
event ack;
// Declare done as alias to ack
event done = ack;
// Event variable with no synchronization object
event empty = null;

initial begin
  #1 -> ack;
  #1 -> empty;
  #1 -> done;
  #1 $finish;
end

always @ (ack)
begin
  $display("ack event emitted");
end

always @ (done)
begin
  $display("done event emitted");
end

/*
always @ (empty)
begin
  $display("empty event emitted");
end
*/

endmodule
