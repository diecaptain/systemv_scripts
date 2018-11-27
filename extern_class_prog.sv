program extern_class_prog;

 `include "extern_class_body.sv"

extern_class c;

initial begin
  c = new();
  c.print();
  $finish;
end

endprogram
