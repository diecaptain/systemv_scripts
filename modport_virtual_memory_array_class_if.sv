//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Declare memory interface
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
interface memory (input bit clk);
  wire [7:0] addr;
  wire [7:0] data_i;
  wire [7:0] data_o;
  wire       rw;
  wire       ce;
  //==============================================
  // Define the DUT modport
  //==============================================
  modport  dut (input  addr, data_i, rw, ce, clk, output data_o);
  //==============================================
  // Define the Testbench Driver modport
  //==============================================
  modport  tb  (output addr, data_i, rw, ce, input data_o, clk);
  //==============================================
  // Define the Testbench Monitor modport
  //==============================================
  modport  mon (input  addr, data_i, rw, ce, clk, data_o);

endinterface
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Simple memory model
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module ram(memory.dut mif);

reg [7:0] memr [0:255];
//==============================================
// Memory read operation
//==============================================
assign mif.data_o = (~mif.rw && mif.ce) ?
     memr[mif.addr] : 8'b0;
//==============================================
// Memory write operation
//==============================================
always @ (posedge mif.clk)
if (mif.ce && mif.rw)
  memr[mif.addr] = mif.data_i;

endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Top level of memory model
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module ram_top(memory mif[1:3]);

ram U_ram0(mif[1].dut);
ram U_ram1(mif[2].dut);
ram U_ram2(mif[3].dut);

endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Memory top level with DUT and testbench
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module mem_tb();
  logic clk = 0;
  always #1 clk = ~clk;
  //==============================================
  // interface with clock connected
  //==============================================
  memory mem_if[1:3](clk);
  //==============================================
  // Connect the DUT
  //==============================================
  ram_top U_ram_top(mem_if);
  //==============================================
  // Connect the testbench
  //==============================================
  test U_test(mem_if);
endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Testbench top level program
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
program test(memory tbf[1:3]);
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Driver class
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  class driver;
    virtual memory.tb ports[1:3];
    //==============================================
    // Constructor
    //==============================================
    function new(virtual memory.tb ports[1:3]);
       this.ports = ports;
    endfunction
    //==============================================
    // Test vector generation
    //==============================================
    task run_t(integer portno);
      integer i = 0;
      for (i= 0; i < 4; i ++) begin
         @ (posedge ports[portno].clk);
         $display("Writing address %0d with data %0d",i,i);
         ports[portno].addr = i;
         ports[portno].data_i = i;
         ports[portno].ce = 1;
         ports[portno].rw = 1;
         @ (posedge ports[portno].clk);
         ports[portno].addr = 0;
         ports[portno].data_i = 0;
         ports[portno].ce = 0;
         ports[portno].rw = 0;
      end
      for (i= 0; i < 4; i ++) begin
         @ (posedge ports[portno].clk);
         $display("Read address %0d",i);
         ports[portno].addr = i;
         ports[portno].data_i = i;
         ports[portno].ce = 1;
         ports[portno].rw = 0;
         @ (posedge ports[portno].clk);
         ports[portno].addr = 0;
         ports[portno].data_i = 0;
         ports[portno].ce = 0;
         ports[portno].rw = 0;
      end
    endtask
  endclass
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Monitor class
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  class monitor;
    reg  [7:0] tbmem [255];
    virtual memory.mon ports[1:3];
    //==============================================
    // Constructor
    //==============================================
    function new(virtual memory.mon ports[1:3]);
       this.ports = ports;
    endfunction
    //==============================================
    // Monitor method
    //==============================================
    task run_t(integer portno);
      while(1) begin
         @ (negedge ports[portno].clk);
         if (ports[portno].ce) begin
           if (ports[portno].rw) begin
             tbmem[ports[portno].addr] = ports[portno].data_i;
           end else begin
             if (ports[portno].data_o != tbmem[ports[portno].addr]) begin
               $display("Error : Expected %0x Got %0x",
                  tbmem[ports[portno].addr],ports[portno].data_o);
             end else begin
               $display("Pass  : Expected %0x Got %0x",
                  tbmem[ports[portno].addr],ports[portno].data_o);
             end
           end
         end
      end
    endtask
  endclass
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Wrapper for monitor and driver
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  class  tb_shell;
    driver   tb_driver  ;
    monitor  tb_monitor ;
    //==============================================
    // Constructor
    //==============================================
    function new (virtual memory tbfl[1:3]);
      tb_driver   = new(tbfl);
      tb_monitor  = new(tbfl);
    endfunction
    //==============================================
    // Method to fork of Monitor and Drivers
    //==============================================
    task run_t();
      for (int portno = 1; portno <= 3; portno++) begin
         automatic int portno_t = portno;
         fork
           tb_monitor.run_t(portno_t);
         join_none
      end
      for (int portno = 1; portno <= 3; portno++) begin
         automatic int portno_t = portno;
         fork
           tb_monitor.run_t(portno_t);
         join_none
      end
      fork
         begin
           tb_driver.run_t(1);
         end
         begin
           #100 tb_driver.run_t(2);
         end
         begin
           #200 tb_driver.run_t(3);
         end
        join
      endtask
  endclass
  //==============================================
  // Initial block to start the testbench
  //==============================================
  initial begin
    tb_shell shell = new(tbf);
    shell.run_t();
    #10 $finish;
  end
endprogram
