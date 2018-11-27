module  struct_expr_operator();

typedef struct {
  int x;
  int y;
} myStruct;

myStruct s1;
int k = 1;

initial begin
  #1 s1 = '{1, 2+k};
  // by position
  #1 $display("Value of x = %g y = %g by position", s1.x, s1.y);
  #1 s1 = '{x:2, y:3+k};
  // by name
  #1 $display("Value of s1 ", s1, " by name");
  #1 $finish;
end

endmodule
