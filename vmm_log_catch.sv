//  	vcs -sverilog -ntb_opts rvm vmm_log_catch.sv -R +rvm_log_default=verbose
`include "vmm.sv"

class handler extends vmm_log_catcher; 

   int n = 0;

   virtual function void caught(vmm_log_msg msg);
      msg.effective_typ = vmm_log::NOTE_TYP;
      msg.effective_severity = vmm_log::NORMAL_SEV;
      this.n++;
      this.throw(msg);
   endfunction
endclass

class vmm_log_ex;
  vmm_log log;
  integer i;
  handler hdlr = new();

  function new (string name);
    log = new ("vmm_log_ex",name);
  endfunction

  task test ();
    log.catch(hdlr, .text("/I am fatal/"));

    `vmm_verbose (log,"I am verbose");
    `vmm_debug   (log,"I am debug");
    `vmm_note    (log,"I am note");
    `vmm_warning (log,"I am warning");
    `vmm_error   (log,"I am error");
    // Below line will be converted to Normal
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
