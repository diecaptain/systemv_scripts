//  	vcs -sverilog -ntb_opts rvm vmm_scenario_gen_example.sv -R +rvm_log_default=verbose
`include "vmm.sv"

// Note : This is not exact representation of AHB data class
// All data class needs to extend from vmm_data
class ahb_data extends vmm_data;
  vmm_log log;
  // Declare all the fields
  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit        cmd;

  // Make sure all variables have init value
  function new(vmm_log log = null);
    int i;
    super.new(log);
    this.log        = log;
    this.addr       = 0;
    this.data       = 0;
    this.cmd        = 0;
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
    cpy.data = this.data;
    cpy.cmd = this.cmd;
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
    msg = $psprintf("%s DATA          : 32'h%x\n",msg,data);
    msg = $psprintf("%s CMD           : 1'b%b\n",msg,cmd);

    psdisplay = msg;
  endfunction
endclass

// We need to add below line to construct vmm_channel for object ahb_data
`vmm_channel(ahb_data)
`vmm_scenario_gen(ahb_data,"SCENARIO GEN")


class my_ahb_data_scenario extends ahb_data_scenario;
   int add_trans_index,sub_trans_index;
   vmm_log log;

   constraint add_items {
     if ($void(scenario_kind) == add_trans_index) {
       length   == 2;
       repeated == 0;
       foreach(items[i]) {
         if (i % 2 == 0) {
            this.items[i].cmd == 0;
         } else if (i % 2 == 1) {
            this.items[i].cmd == 1;
            this.items[i].addr == this.items[i-1].addr;
         }
       }
     }
   }

   constraint sub_items {
     if ($void(scenario_kind) == add_trans_index) {
       length   == 2;
       repeated == 0;
       foreach(items[i]) {
         if (i % 2 == 0) {
            this.items[i].cmd == 0;
         } else if (i % 2 == 1) {
            this.items[i].cmd == 1;
            this.items[i].addr == this.items[i-1].addr;
         }
       }
     }
   }

   function new(vmm_log log);
     super.new();
     this.log = log;
     this.add_trans_index = define_scenario(" ADD ",2);
     this.sub_trans_index = define_scenario(" SUB ",2);
   endfunction

endclass

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

program vmm_scenario_gen_example();
  vmm_log log                  = new("test","ahb_data");
  ahb_data_channel fifo        = new ("CHANNEL","FIFO");
  ahb_data_scenario_gen src    = new("SOURCE",-1,fifo);
  my_ahb_data_scenario add_sub = new(log);

  sink   snk  = new(log,"SINK",fifo);

  initial begin
     // Set number of transactions to generate
     src.stop_after_n_insts = 1;
     src.stop_after_n_scenarios = 2;
     $display ("Size %0d",src.scenario_set.size());
     src.scenario_set[0] = add_sub;
     snk.start_xactor();
     src.start_xactor();
     // Wait for source to start
     src.notify.wait_for(vmm_xactor::XACTOR_BUSY);
     $display("Came out of SOURCE START");
     // Wait for source to end
     src.notify.wait_for(ahb_data_scenario_gen::DONE);
     $display("Came out of SOURCE DONE");
     #10;
  end
endprogram
