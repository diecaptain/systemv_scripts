//  	vcs -sverilog -ntb_opts rvm vmm_env_example.sv -R +rvm_log_default=verbose
`include "vmm.sv"

// Note : This is not exact representation of AHB data class
// All data class needs to extend from vmm_data
class ahb_data extends vmm_data;
  vmm_log log;
  // Declare all the fields
  rand bit [31:0] addr;
  rand bit [31:0] data [16];
  rand bit [3:0]  beats;

  // Make sure all variables have init value
  function new(vmm_log log = null);
    int i;
    super.new(log);
    this.log  = log;
    this.addr       = 0;
    for (i = 0; i < 16; i ++) begin
      this.data[1] = 0;
    end
    this.beats     = 1;
  endfunction
  virtual function vmm_data copy(vmm_data to = null);
     ahb_data cpy;
     int i;
     if (to == null) begin
       cpy = new (log);
     end else begin
       if (!($cast(cpy,to))) begin
         `vmm_fatal(log,"Object is not of type ahb_data");
       end
     end
    cpy.addr = this.addr;
    for (i = 0; i < 16; i ++) begin
      cpy.data[i] = this.data[1];
    end
    copy         = cpy;
  endfunction


  // Print message
  function void display(string prefix = "");
    if (is_valid()) begin
     `vmm_debug(log,$psprintf("%s",psdisplay(prefix)));
    end else begin
     `vmm_error(log,$psprintf("%s",psdisplay(prefix)));
    end
  endfunction

  // Return the string members and their values
  virtual function string psdisplay(string prefix = "");
    string msg;
    int i;
    msg = $psprintf("   %s\n", prefix);
    msg = $psprintf("%s ADDRESS       : 32'h%x\n",msg,addr);
    msg = $psprintf("%s BEATS         : %0d\n",msg,beats);

    for (i = 0; i < beats; i++) begin
      msg = $psprintf("%s DATA[%2d]      : 32'h%x\n",msg,i,data[i]);
    end
    psdisplay = msg;
  endfunction
endclass

// We need to add below line to construct vmm_channel for object ahb_data
`vmm_channel(ahb_data)
`vmm_atomic_gen(ahb_data,"ATOMIC GEN")

// This class sinks transactions
class sink extends vmm_xactor;
  ahb_data_channel fifo;
  vmm_log log;

  function new(vmm_log log, string name, ahb_data_channel fifo);
    super.new(name,name);
    this.log = log;
    this.fifo = fifo;
  endfunction

  virtual task main();
     ahb_data d;
     super.main();
     while (1) begin
       wait_if_stopped_or_empty(fifo);
       fifo.get(d);
       // Indicate we are processing the object
       d.notify.indicate(vmm_data::STARTED);
       #10;
       // Indicate we done with processing the object
       $display("Indicating done processing");
       d.notify.indicate(vmm_data::ENDED);
     end
  endtask
endclass

class my_env extends vmm_env;
  vmm_log             log ;
  ahb_data_channel    fifo;
  ahb_data_atomic_gen src ;
  sink                snk ;

  function new();
    super.new("my_env");
    log = new("my_env","env");
  endfunction

  virtual function void gen_cfg();
    super.gen_cfg();
    `vmm_warning(this.log,"gen_cfg not implemented for this example");
  endfunction

  virtual function void build();
    super.build();
    fifo = new ("CHANNEL","FIFO");
    src  = new("SOURCE",-1,fifo);
    snk  = new(log,"SINK",fifo);
  endfunction

  virtual task reset_dut();
    super.reset_dut();
    `vmm_warning(this.log,"reset_dut not implemented for this example");
  endtask

  virtual task cfg_dut();
    super.cfg_dut();
    `vmm_warning(this.log,"cfg_dut not implemented for this example");
  endtask

  virtual task start();
    super.start();
    src.stop_after_n_insts = 2;
    snk.start_xactor();
    src.start_xactor();
  endtask

  virtual task wait_for_end();
    super.wait_for_end();
    // Wait for source to end
    src.notify.wait_for(ahb_data_atomic_gen::DONE);
    `vmm_note(this.log,"Generator is done with generation");
  endtask

  virtual task stop();
    super.stop();
    #100;
    snk.stop_xactor();
    src.stop_xactor();
  endtask

  virtual task report();
    super.report();
    `vmm_note(this.log,"Generator is done with generation");
  endtask

endclass

program vmm_env_example();

  my_env env = new();

  initial begin
     env.run();
     #100;
  end

endprogram
