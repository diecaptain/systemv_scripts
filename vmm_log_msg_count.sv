//  	vcs -sverilog -ntb_opts rvm vmm_log_msg_count.sv -R +rvm_log_default=verbose
`include "vmm.sv"

class vmm_log_ex;
  vmm_log log;

  function new (string name);
    log = new ("vmm_log_ex",name);
  endfunction

  task test ();
    `vmm_verbose (log,"I am verbose");
    `vmm_debug   (log,"I am debug");
    repeat (2)
    `vmm_note    (log,"I am note");
    repeat (4)
    `vmm_warning (log,"I am warning");
    `vmm_error   (log,"I am error");
    repeat (2)
    `vmm_note    (log,"I am note");

    `vmm_note (log,$psprintf("Verbose count %0d",
       log.get_message_count(vmm_log::VERBOSE_SEV,"/./","/./",1)));
    `vmm_note (log,$psprintf("Debug count %0d",
       log.get_message_count(vmm_log::DEBUG_SEV,"/./","/./",1)));
    `vmm_note (log,$psprintf("Normal count %0d",
       log.get_message_count(vmm_log::NORMAL_SEV,"/./","/./",1)));
    `vmm_note (log,$psprintf("Warning count %0d",
       log.get_message_count(vmm_log::WARNING_SEV,"/./","/./",1)));
    `vmm_note (log,$psprintf("Error count %0d",
        log.get_message_count(vmm_log::ERROR_SEV,"/./","/./",1)));
  endtask
endclass


program test();
  vmm_log_ex ex = new("vmm_log_test");

  initial begin
    ex.test();
  end
endprogram
