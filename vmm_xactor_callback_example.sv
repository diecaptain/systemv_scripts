//  	vcs -sverilog -ntb_opts rvm vmm_xactor_callback_example.sv -R +rvm_log_default=verbose
`include "vmm.sv"

class my_data extends vmm_data;
  vmm_log log;
  int corrupt_crc;
  int crc;
  int addr;
  int data;
  int drop;
  function new(vmm_log log);
    super.new(log);
    this.log         = log;
    this.corrupt_crc = 0;
    this.crc         = 0;
    this.addr        = 0;
    this.data        = 0;
    this.drop        = 0;
  endfunction
endclass

// Need to extend from base class vmm_xactor_callback
virtual class my_callback extends vmm_xactor_callbacks;
  vmm_log log;

  function new(vmm_log log);
    super.new();
    this.log = log;
  endfunction

  virtual function my_cb(ref my_data my_d);
    `vmm_warning(this.log,"Nothing is implemented here");
  endfunction

endclass

// Need to extend from base class my_callback
class my_abc_callback extends my_callback;
  int cnt;
  function new(vmm_log log);
    super.new(log);
    cnt = 0;
  endfunction

  virtual function my_cb(ref my_data my_d);
    cnt ++;
    if (cnt %2 == 0) begin
      `vmm_warning(this.log,"Corrupting CRC");
      my_d.corrupt_crc = 1;
    end
  endfunction
endclass

// Need to extend from base class my_callback
class my_xyz_callback extends my_callback;
  int cnt;
  function new(vmm_log log);
    super.new(log);
    cnt = 0;
  endfunction

  virtual function my_cb(ref my_data my_d);
    cnt ++;
    if (cnt %2 == 1) begin
      `vmm_warning(this.log,"Doing nothing");
    end
  endfunction
endclass

// Need to extend from base class vmm_xactor
class eth_tx extends vmm_xactor;
  vmm_log log;

  function new(vmm_log log,string name);
    super.new(name, "parent");
    this.log = log;
  endfunction

  virtual task main();
    super.main();
    fork
      begin
        this.bfm();
      end
    join_none
  endtask

  task bfm();
   my_data mdata;
    while(1) begin
      #10; // This can be clock event
      wait_if_stopped();
      mdata = new(log);
      `vmm_note(log,"Ethernet transmit bfm is running");
      #10; // Lets execute callback
      `vmm_callback(my_callback,my_cb(mdata));
      if (mdata.corrupt_crc) begin
        `vmm_warning(this.log,"Corrupting CRC on user request");
      end
    end
  endtask
endclass

program vmm_xactor_callback_example();
  vmm_log log = new("test","test");
  eth_tx  tx    = new(log,"PROGRAM");
  my_xyz_callback xyz = new(log);
  my_abc_callback abc = new(log);

  initial begin
     tx.append_callback(abc);
     tx.append_callback(xyz);
     tx.start_xactor();
     #40;
  end
endprogram
