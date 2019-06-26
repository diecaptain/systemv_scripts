module uvm_dut_example(dut_if_name dif);
  import uvm_package::*;
  
  // Events
  always @ (posedge dif.clock or negedge dif.reset)
  begin
    `uvm_info("", $sformatf("DUT received portA=%b, portB=%b",
                            dif.portA, dif.portB), UVM_MEDIUM);
  end
endmodule
