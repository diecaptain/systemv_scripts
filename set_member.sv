module set_member();

int array [$] = {1,2,3,4,5,6,7};
int check = 0;

initial begin
  if (check inside {array}) begin
    $display("check is inside array");
  end else begin
    $display("check is not inside array");
  end
  check = 5;
  if (check inside {array}) begin
    $display("check is inside array");
  end else begin
    $display("check is not inside array");
  end
  check = 1;
  // Constant range
  if (check inside {[0:10]}) begin
    $display("check is inside array");
  end else begin
    $display("check is not inside array");
  end

end

endmodule
