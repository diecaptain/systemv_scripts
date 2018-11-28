//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface count_if #(WIDTH = 4) (input clk);
  logic   reset;
  logic   enable;
  logic  [WIDTH-1 : 0] count;
  //=================================================
  // Modports declaration
  //=================================================
  modport dut (input clk, reset, enable, output count);
  modport tb  (input clk, count, output reset, enable, import monitor);
  //=================================================
  // Monitor Task
  //=================================================
  task  monitor();
    while (1) begin
      @ (posedge clk);
      if (enable) begin
        $display ("@%0dns reset %b enable %b count %b",
          $time, reset, enable, count);
      end
    end
  endtask
endinterface
//+++++++++++++++++++++++++++++++++++++++++++++++++
// Counter DUT
//+++++++++++++++++++++++++++++++++++++++++++++++++
module counter #(WIDTH = 4) (count_if.dut dif);
  //=================================================
  // Dut implementation
  //=================================================
  always @ (posedge dif.clk)
    if (dif.reset) begin
       dif.count <= {WIDTH{1'b0}};
    end else if (dif.enable) begin
       dif.count ++;
    end
endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++
// Program for counter (TB)
//+++++++++++++++++++++++++++++++++++++++++++++++++
program counterp #(WIDTH = 4) (count_if.tb tif);
  //=================================================
  // Default Clocking for using ##<n> delay
  //=================================================
  default clocking cb @ (posedge tif.clk);

  endclocking
  //=================================================
  // Generate the test vector
  //=================================================
  initial begin
    // Fork of the monitor
    fork
      tif.monitor();
    join_none
    tif.reset <= 1;
    tif.enable <= 0;
    ##10 tif.reset <= 0;
    ##1 tif.enable <= 1;
    ##10 tif.enable <= 0;
    ##5 $finish;
  end
endprogram
//+++++++++++++++++++++++++++++++++++++++++++++++++
// Top Level
//+++++++++++++++++++++++++++++++++++++++++++++++++
module simple_parameter_if();
  localparam  WIDTH = 5;
  logic clk = 0;
  always #1 clk ++;

  count_if #(WIDTH)         cif (clk);
  counter  #(.WIDTH(WIDTH)) dut (cif);
  counterp #(WIDTH)         tb  (cif);

endmodule
