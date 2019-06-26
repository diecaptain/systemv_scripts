`include uvm_macros.svh
`include uvm_package_example.sv

module uvm_top_example;

  import uvm_pkg::*;              // Import UVM Package Factory Base
  import pkg_name::*;             // Import current package under factory base
  
  // Instantiate DUT Interface
  dut_if dut_if_name ();
  
  // Instantiate DUT
  dut    dut_name ( .dut_inst_if_name(dut_if_name) );

  // Events
  initial
    begin
      // Clock Generator
      dut_if_name.clock = 0;
      forever #10 dut_if_name.clock =~ dut_if_name.clock;
    end
  
  initial
    begin
      // Calling UVM Config Database
      uvm_config_db #(virtual dut_if)::set(...);
      // Declaring $finish
      uvm_top.finish_on_completion = 1;
      // use UVM Run Test factory base to run custom test
      run_test("test_name");
    end
  
 endmodule
