module systasks_array();
// 1 dimension
reg [7:0] me = 10;
// 2 dimension array of Verilog 2001
reg [7:0] mem [0:3] = '{8'h0,8'h1,8'h2,8'h3};
// one more example of multi dimention array
reg [7:0] mem1 [0:1] [0:3] =
   '{'{8'h0,8'h1,8'h2,8'h3},'{8'h4,8'h5,8'h6,8'h7}};
// One more example of multi dimention array
reg [7:0] [0:4] mem2 [0:1] =
   '{{8'h0,8'h1,8'h2,8'h3},{8'h4,8'h5,8'h6,8'h7}};
// One more example of multi dimention array
reg [7:0] [0:4] mem3 [0:1] [0:1]  =
   '{'{{8'h0,8'h1,8'h2,8'h3},{8'h4,8'h5,8'h6,8'h7}},
   '{{8'h0,8'h1,8'h2,8'h3},{8'h4,8'h5,8'h6,8'h7}}};
// Multi arrays in same line declaration
bit [7:0] [31:0] mem4 [1:5] [1:10], mem5 [0:255];

initial begin
  // $dimensions usage
  $display ("$dimensions in me %0d mem %0d mem1 %0d",
     $dimensions(me),$dimensions(mem),$dimensions(mem1));
  // $unpacked_dimensions
  $display ("$unpacked_dimensions in me %0d mem %0d mem1 %0d",
     $unpacked_dimensions(me),$unpacked_dimensions(mem),
     $unpacked_dimensions(mem1));
  // $left
  $display ("$left in me %0d mem %0d mem1 %0d",
     $left(me),$left(mem),$left(mem1));
  // $right
  $display ("$right in me %0d mem %0d mem1 %0d",
     $right(me),$right(mem),$right(mem1));
  // $low
  $display ("$low in me %0d mem %0d mem1 %0d",
     $low(me),$low(mem),$low(mem1));
  // $high
  $display ("$high in me %0d mem %0d mem1 %0d",
     $high(me),$high(mem),$high(mem1));
  // $increment
  $display ("$increment in me %0d mem %0d mem1 %0d",
     $increment(me),$increment(mem),$increment(mem1));
  // $size
  $display ("$size in me %0d mem %0d mem1 %0d",
     $size(me),$size(mem),$size(mem1));

  #1 $finish;
end

endmodule
