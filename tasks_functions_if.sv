//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface task_function_if (input clk);
  logic    req;
  logic    gnt;
  //=================================================
  //  Clocking block for tb modport
  //=================================================
  clocking cb @ (posedge clk);
    input  gnt;
    output req;
  endclocking
  //=================================================
  //  Task inside a interface, You can basically
  // Write a BFM, who's input can be a class or
  // a mailbox, so on..... SO COOL!!!!
  //=================================================
  task drive_req (input integer delay, input bit value);
    $display("@%0dns Before driving req %b from task at %m", $time, req);
    repeat (delay) @ (posedge clk);
    req = value;
    $display("@%0dns Driving req %b from task at %m", $time, req);
  endtask
  //=================================================
  //  Mod port with exporting and importing tasks
  //=================================================
  modport  dut (input clk,req, output gnt
      //, export print_md, import print_tb
     );
  //=================================================
  //  Mod Port with exporting and importing tasks
  //=================================================
  modport  tb (clocking cb, input clk,
     import drive_req
     //, print_md, export print_tb
     );

endinterface
//+++++++++++++++++++++++++++++++++++++++++++++++++
// DUT Code
// Uses just the interface keyword
//+++++++++++++++++++++++++++++++++++++++++++++++++
module dut_ex (interface abc);
  //=================================================
  //  Task print_md, which is exported
  //=================================================
  //task abc.print_md (input logic something);
  //    $display("@%0dns Inside %m : From print_md", $time);
  //    $display("Value of req %b gnt %b in %m",abc.req, abc.gnt);
  //endtask
  //=================================================
  //  Simple DUT Logic and calling task in another
  //  Module through interface
  //=================================================
   always @ (posedge abc.clk)
   begin
      abc.gnt <= abc.req;
      $display("@%0dns Request is %b", $time, abc.req);
      if (abc.req === 1'bx) begin
        //abc.print_tb(1'bx);
      end
      if (abc.req === 1'b0) begin
        //abc.print_tb(1'b0);
      end
      if (abc.req === 1'b1) begin
        //abc.print_tb(1'b1);
      end
    end

endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
// TB Code
// Uses just the interface keyword
//+++++++++++++++++++++++++++++++++++++++++++++++++
module tb_ex (interface xyz);
  //=================================================
  //  Task print_tb, which is exported
  //=================================================
  //task xyz.print_tb (input bit something);
  //  $display("@%0dns %m Value of req : %b", $time, something);
  //endtask
  //=================================================
  // Test vector generation with task in another
  // Module and in interface calling
  //=================================================
  initial begin
    xyz.cb.req <= 0;
    xyz.drive_req(10,1);
    xyz.drive_req(10,0);
    //xyz.print_md(0);
    #2 $finish;
  end

endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++
// Top level testbench file
//+++++++++++++++++++++++++++++++++++++++++++++++++
module tasks_functions_if();
  //=================================================
  //  Clock generator
  //=================================================
  logic clk = 0;
  always #1 clk++;
  //=================================================
  //  Interface instance
  //=================================================
  task_function_if tfif(clk);
  //=================================================
  //  DUT and TB instance
  //=================================================
  dut_ex U_dut(tfif.dut);
  tb_ex  U_tb(tfif.tb);

endmodule
