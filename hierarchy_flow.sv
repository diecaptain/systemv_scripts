//+++++++++++++++++++++++++++++++++++++++++++++++++
// Child Module
//+++++++++++++++++++++++++++++++++++++++++++++++++
module child();

//=================================================
// Method inside child
//=================================================
task print();
 $display("%m : Inside Module child");
endtask

initial begin
  $root.top.U.U.print();
end

endmodule


//+++++++++++++++++++++++++++++++++++++++++++++++++
// Parent Module
//+++++++++++++++++++++++++++++++++++++++++++++++++
module parent();

//=================================================
// Method inside parent
//=================================================
task print();
 $display("%m : Inside Module praent");
endtask

child U ();

initial begin
  $root.top.U2.print();
  $root.top.U.print();
end

endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
// Top Module
//+++++++++++++++++++++++++++++++++++++++++++++++++
module top();

parent U();
child U2();

//=================================================
// Method inside top
//=================================================
task print();
 $display("%m : Inside Module top");
endtask

endmodule
