//  	vcs -sverilog -ntb_opts rvm vmm_notify_example.sv -R +rvm_log_default=verbose
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
  function new(vmm_log log);
    int i;
    super.new(log);
    this.log  = log;
    this.addr       = 0;
    for (i = 0; i < 16; i ++) begin
      this.data[1] = 0;
    end
    this.beats     = 1;
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

// This class generates transactions
class source extends vmm_xactor;
  vmm_log log;
  ahb_data_channel fifo;
  // Declare new notify event
  // As int
  int SOURCE_DONE;
  // As event
  typedef enum {SOURCE_START} notifications_e;


  function new(vmm_log log,string name, ahb_data_channel fifo);
    super.new(name, name);
    this.log = log;
    this.fifo = fifo;
    // Configure SOURCE_DONE as ON_OFF type
    this.SOURCE_DONE = this.notify.configure(-1,vmm_notify::ON_OFF);
    this.notify.configure(SOURCE_START);
  endfunction

  virtual task main();
    int i;
    ahb_data mdata;
    super.main();
    #10;
    // Generate 2 transactions
    this.notify.indicate(SOURCE_START);
    for (i = 0; i < 2; i++) begin
      mdata = new (log);
      fifo.sneak(mdata);
      // Wait for object to be process before generating next object
      mdata.notify.wait_for(vmm_data::ENDED);
      $display("Time to generate next object");
    end
    // Done with generation, so indicate done
    this.notify.indicate(SOURCE_DONE);
  endtask

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

program vmm_notify_example();
  vmm_log log = new("test","ahb_data");
  ahb_data_channel fifo = new ("CHANNEL","FIFO");
  source src = new(log,"SOURCE",fifo);
  sink   snk  = new(log,"SINK",fifo);

  initial begin
     snk.start_xactor();
     src.start_xactor();
     // Wait for source to start
     src.notify.wait_for(source::SOURCE_START);
     $display("Came out of SOURCE START");
     // Wait for source to end
     src.notify.wait_for(src.SOURCE_DONE);
     $display("Came out of SOURCE DONE");
     #100;
  end
endprogram
