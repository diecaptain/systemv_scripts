//  	vcs -sverilog -ntb_opts rvm vmm_data_example.sv -R +rvm_log_default=verbose
`include "vmm.sv"

// Note : This is not exact representation of AHB data class
// All data class needs to extend from vmm_data
class ahb_data extends vmm_data;
  vmm_log log;
  // You should use enum, when needed
  typedef enum {OKAY,ERROR,RETRY,SPLIT} rsp_t;
  typedef enum {IDLE,BUSY,NONSEQ,SEQ} tnr_t;
  typedef enum {WRITE,READ} cmd_t;
  typedef enum {SINGLE,INCR,WRAP4,INCR4,WRAP8,
  INCR8,WRAP16,INCR16} burst_t;

  // Declare all the fields
  rand bit [31:0] addr;
  rand bit [31:0] data [16];
  rand bit [3:0]  beats;
  rand tnr_t  transfer;
  rand rsp_t  response;
  rand cmd_t  cmd;
  rand burst_t burst;

  // Make sure all variables have init value
  function new(vmm_log log);
    int i;
    super.new(log);
    this.log  = log;
    this.addr       = 0;
    for (i = 0; i < 16; i ++) begin
      this.data[i] = 0;
    end
    this.beats     = 0;
    this.transfer  = IDLE;
    this.response  = OKAY;
    this.cmd       = WRITE;
    this.burst     = SINGLE;
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
    msg = $psprintf("%s COMMAND       : %s\n",msg,cmd.name());
    msg = $psprintf("%s TRANSFER      : %s\n",msg,transfer.name());
    msg = $psprintf("%s RESPONSE      : %s\n",msg,response.name());
    msg = $psprintf("%s BEATS         : %0d\n",msg,beats);
    msg = $psprintf("%s BURST         : %s\n",msg,burst.name());

    for (i = 0; i < beats; i++) begin
      msg = $psprintf("%s DATA[%2d]      : 32'h%x\n",msg,i,data[i]);
    end
    psdisplay = msg;
  endfunction

  virtual function bit is_valid(bit silent = 1, int kind = -1);
    is_valid = (response != ERROR);
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
    cpy.beats    = this.beats    ;
    cpy.transfer = this.transfer ;
    cpy.response = this.response ;
    cpy.cmd      = this.cmd      ;
    cpy.burst    = this.burst    ;
    copy         = cpy;
  endfunction

  virtual function bit compare( vmm_data to, output string diff,
     input int kind = -1);
    int cmp = 1;
    ahb_data cp;
    if (to == null) begin
      `vmm_error(log,"Passed pointer to copy method is null");
      return 0;
    end else begin
      if (!($cast(cp,to))) begin
        `vmm_fatal(log,"Object is not of type ahb_data");
      end
    end
    if (addr != cp.addr) begin
      diff = $psprintf("Expected 32'h%x Got 32'h%x",addr, cp.addr);
      return 0;
    end
    if (beats != cp.beats) begin
      diff = $psprintf("Expected 32'h%x Got 32'h%x",beats, cp.beats);
      return 0;
    end
    // You can add reset of the code here
    compare = cmp;
  endfunction

endclass

program vmm_data_example();
  vmm_log log = new("vmm_log_test","ahb_data");
  ahb_data mdata = new (log);
  initial begin
    if (mdata.randomize() == 0) begin
    end else begin
     mdata.display("PROGRAM");
    end
    #10;
  end
endprogram
