program aop_memebers;
 // Define the class
 class aop;
    integer i;
    function void print ();
      $display ("[1] Value of i %0d",i);
    endfunction
 endclass
 // Add new variable j and method print2 to aop class
 extends aop_extend (aop);
    integer j;
    function void print2 ();
      $display ("[2] Value of i %0d",i);
      $display ("[2] Value of j %0d",j);
    endfunction
 endextends
 // Create instance of the aop class
 aop a_;

 initial begin
   a_ = new ();
   a_.i = 10;
   a_.j = 11;
   a_.print();
   a_.print2();
 end

endprogram
