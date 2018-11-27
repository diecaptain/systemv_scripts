`timescale 1ns/100ps
// Type Define a struct
typedef struct {
  byte a;
  reg b;
  shortint unsigned c;
} myStruct;

module struct_literals ();

  myStruct object = '{10,0,100};

  myStruct objectarray [0:1] = '{'{10,0,100},'{11,1,101}};

  initial begin
    $display ("a = %b, b = %b, c = %h", object.a, object.b, object.c);
    object.b = 1;
    $display ("a = %b, b = %b, c = %h", object.a, object.b, object.c);
    object.c = 16'hDEAD;
    $display ("a = %b, b = %b, c = %h", object.a, object.b, object.c);
    $display ("Printing array objects");
    $display ("a = %b, b = %b, c = %h", objectarray[0].a, objectarray[0].b, objectarray[0].c);
    $display ("a = %b, b = %b, c = %h", objectarray[1].a, objectarray[1].b, objectarray[1].c);
    #1 finish;

  end

endmodule
