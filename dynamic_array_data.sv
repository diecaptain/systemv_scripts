module dynamic_array_data();

// Declare dynamic array
reg [7:0] mem [];
reg [7:0] id [];

initial begin
  // Allocate array for 4 locations
  $display ("Setting array size to 4");
  mem = new[4];
  $display("Initial the array with default values");
  for (int i = 0; i < 4; i++) begin
    mem[i] = i;
    $display ("value at location %g of mem is %d", mem[i]);
  end

  // Doubling the size of array, with old content still valid
  /*id = new[8](mem);
  // Print current size
  $display ("Current array size is %d",id.size());
  for (int i = 0; i < 8; i ++) begin
    $display ("Value at location %g is %d ", i, id[i]);
  end
  // Delete array
  $display ("Deleting the array");
  id.delete();
  $display ("Current array size is %d",id.size());*/
  #1 $finish;
end

endmodule
