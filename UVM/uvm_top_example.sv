module uvm_top_example;

  import uvm_pkg::*;              // Import UVM Package Factory Base
  import pkg_name::*;             // Import current package under factory base
  
  // Instantiate DUT Interface
  dut_if dut_if_name ();
  
  // Instantiate DUT
  dut    dut_name ( .dif(dut_if_name) );

  // Events
  initial
  begin
    // use UVM Run Test factory base to run custom test
    run_test("test_name");
  end
  
 endmodule
