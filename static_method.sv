`define PRINT task print (); \
 begin \
   $write("%s -> Size is %0d\n",this.name, this.size); \
 end \
endtask

program static_method;
  // Class with constructor, with no parameter
  class A;
     // Make size as static
     static integer size;
     string name;
     // Constructor
     function new (string name);
       begin
         this.name = name;
         this.size = 0;
       end
     endfunction
     // static Increment size task
     static task inc_size();
       begin
         size ++; // Ok to access static member
         $write("size is incremented\n");
         // Not ok to access non static member name
         //$write("%s -> size is incremented\n",name);
       end
     endtask
     // Task in class (object method)
     `PRINT
   endclass

   A a;

   initial begin
     a = new("A");
     a.inc_size();
     a.print();
   end

endprogram
