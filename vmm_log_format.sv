//  	vcs -sverilog -ntb_opts rvm vmm_log_format.sv -R +rvm_log_default=verbose
`include "vmm.sv"

class my_log_format extends vmm_log_format;
  virtual function string format_msg( string name,
    string instance, string msg_type, string severity,
    ref string lines[$ ]);
    format_msg = $psprintf("[%0t] %s [%s] : ", $time, name, msg_type);
    foreach (lines [l] ) begin
      format_msg = $psprintf("%s %s", format_msg, lines[l]);
    end
  endfunction
endclass

class vmm_log_ex;
  vmm_log log;
  integer i;

  function new (string name);
    my_log_format fmt = new();
    log = new ("vmm_log_ex",name);
    log.set_format(fmt);
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


program test();
  vmm_log_ex ex = new("vmm_log_test");

  initial begin
    ex.test();
  end
endprogram
