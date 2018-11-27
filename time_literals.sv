`timescale 1ns / 100ps
module time_literals ();

  time a;

  initial begin
    $monitor ("@ %gns a = %t", $time, a);
    #1 a = 1ns;
    #1 a = 200ps;
    #1 a = 23ns;
    #1 $finish;
  end

endmodule
