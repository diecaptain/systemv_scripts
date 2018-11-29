// vcs -sverilog -ntb_opts rvm vmm_log_example.sv -R +rvm_log_default=verbose
`include "vmm.sv"

class vmm_log_example;
  vmm_log log;
  integer i;

  function new (string name);
    log = new ("vmm_log_example",name);
  endfunction

  task test ();
    `vmm_verbose (log,"I am verbose");
    `vmm_debug   (log,"I am debug");
    `vmm_note    (log,"I am note");
    `vmm_warning (log,"I am warning");
    `vmm_error   (log,"I am error");
    `vmm_fatal   (log, $psprintf("I am fatal %0d",i));
    $display("I should not be printed");
  endtask
endclass


program vmm_log_example();
  vmm_log_example ex = new("vmm_log_test");

  initial begin
    ex.test();
  end
endprogram
