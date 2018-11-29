module system_variable();

  bit signed [2:0] abc;
  int signed       xyz;
  enum {A,B,C=99}  enm;

  typedef struct {bit [7:0] A,B;} AB_t;
  AB_t AB[10];

  parameter int foo = $;

initial begin
  // $typename usage
  $display ("$typename of abc  %s",$typename(abc));
  $display ("$typename of xyz  %s",$typename(xyz));
  $display ("$typename of enm  %s",$typename(enm));
  $display ("$typename of AB_t %s",$typename(AB_t));
  $display ("$typename of AB   %s",$typename(AB));
  $display ("$typename of foo  %s",$typename(foo));
  // $bits usage
  $display ("$bits     of abc  %0d",$bits(abc));
  $display ("$bits     of xyz  %0d",$bits(xyz));
  $display ("$bits     of enm  %0d",$bits(enm));
  $display ("$bits     of AB_t %0d",$bits(AB_t));
  $display ("$bits     of AB   %0d",$bits(AB));
  $display ("$bits     of foo  %0d",$bits(foo));
  // $isunbounded
  $display ("$isunbounded of abc  %0d",$isunbounded(abc));
  $display ("$isunbounded of xyz  %0d",$isunbounded(xyz));
  $display ("$isunbounded of enm  %0d",$isunbounded(enm));
  $display ("$isunbounded of AB   %0d",$isunbounded(AB));
  $display ("$isunbounded of foo  %0d",$isunbounded(foo));
end

endmodule
