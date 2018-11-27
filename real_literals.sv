`timescale 1ns/100ps
module real_literals ();

  real a;
  shortreal b;

  initial begin
    $monitor ("@ %gns a = %e b = %e", $time, a, b);
    a = '0;
    b = 2.0e4;

    #1 a = 3e4;
    // Type casting
    #1 b = shortreal'(a);
    #1 a = 5e-2;
    // Type casting
    #1 b = shortreal'(a);
    #1 $finish;
  end

endmodule
