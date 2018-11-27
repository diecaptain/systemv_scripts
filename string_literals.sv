`timescale 1ns / 100ps
module string_literals ();

  string a;

  initial begin
    $display ("@ %gns a = %s", $time, a);
    a = "Hello diecaptain";
    $display ("@ %gns a = %s", $time, a);
    #1 a = "overwriting old string";
    $display ("@ %gns a = %s", $time, a);
    #1 a = "new string first line \
            new string second line";
    $display ("@ %gns a = %s", $time, a);
    #1 $finish;
  end

endmodule
