module array_methods();

int data [0:9] = '{1,2,3,6,5,7,8,9,9,2};
int queue [$];

initial begin
  queue = data.min;
  $display("Min size element is %0d",queue.pop_front());
  queue = data.max;
  $display("Max size element is %0d",queue.pop_front());
  $display("Sum of array %0d",data.sum);
  $display("Product of array %0d",data.product);
  /*$display("XOR of array %0d",data.xor);
  $display("AND of array %0d",data.and);
  $display("OR  of array %0d",data.or);*/
end

endmodule
