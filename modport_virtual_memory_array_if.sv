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
  ram_top U_ram_top(
    .mif(mem_if)
  );
  //==============================================
  // Connect the testbench
  //==============================================
  test U_test(
   .tbf(mem_if)
  );

endmodule
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Testbench top level program
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
program test(memory tbf[1:3]);
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Driver class
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  class driver;
    virtual memory.tb ports;
    //==============================================
    // Constructor
    //==============================================
    function new(virtual memory.tb ports);
       this.ports = ports;
    endfunction
    //==============================================
    // Test vector generation
    //==============================================
    task run_t();
      integer i = 0;
      for (i= 0; i < 4; i ++) begin
         @ (posedge ports.clk);
         $display("Writing address %0d with data %0d",i,i);
         ports.addr = i;
         ports.data_i = i;
         ports.ce = 1;
         ports.rw = 1;
         @ (posedge ports.clk);
         ports.addr = 0;
         ports.data_i = 0;
         ports.ce = 0;
         ports.rw = 0;
      end
      for (i= 0; i < 4; i ++) begin
         @ (posedge ports.clk);
         $display("Read address %0d",i);
         ports.addr = i;
         ports.data_i = i;
         ports.ce = 1;
         ports.rw = 0;
         @ (posedge ports.clk);
         ports.addr = 0;
         ports.data_i = 0;
         ports.ce = 0;
         ports.rw = 0;
      end
    endtask
  endclass
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Monitor class
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  class monitor;
    reg  [7:0] tbmem [255];
    virtual memory.mon ports;
    //==============================================
    // Constructor
    //==============================================
    function new(virtual memory.mon ports);
       this.ports = ports;
    endfunction
    //==============================================
    // Monitor method
    //==============================================
    task run_t();
      while(1) begin
         @ (negedge ports.clk);
         if (ports.ce) begin
           if (ports.rw) begin
             tbmem[ports.addr] = ports.data_i;
           end else begin
             if (ports.data_o != tbmem[ports.addr]) begin
               $display("Error : Expected %0x Got %0x",
                  tbmem[ports.addr],ports.data_o);
             end else begin
               $display("Pass  : Expected %0x Got %0x",
                  tbmem[ports.addr],ports.data_o);
             end
           end
         end
      end
    endtask
  endclass
  //==============================================
  // Initial block to start the testbench
  //==============================================
  initial begin
    driver   tb_driver0  = new(tbf[1].tb);
    monitor  tb_monitor0 = new(tbf[1].mon);
    driver   tb_driver1  = new(tbf[2].tb);
    monitor  tb_monitor1 = new(tbf[2].mon);
    driver   tb_driver2  = new(tbf[3].tb);
    monitor  tb_monitor2 = new(tbf[3].mon);
    fork
      begin
        tb_monitor0.run_t();
      end
      begin
        tb_monitor1.run_t();
      end
      begin
        tb_monitor2.run_t();
      end
   join_none
   fork
      begin
        tb_driver0.run_t();
      end
      begin
        #100 tb_driver1.run_t();
      end
      begin
        #200 tb_driver2.run_t();
      end
     join
    #10 $finish;
  end
endprogram
