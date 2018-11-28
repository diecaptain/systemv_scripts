//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface mem_if (input wire clk);
  logic        reset;
  logic        we_sys;
  logic        cmd_valid_sys;
  logic        ready_sys;
  logic  [7:0] data_sys;
  logic  [7:0] addr_sys;
  logic        we_mem;
  logic        ce_mem;
  logic  [7:0] datao_mem;
  logic  [7:0] datai_mem;
  logic  [7:0] addr_mem;
  //=================================================
  // Modport for System interface
  //=================================================
  modport  system (input clk,reset,we_sys, cmd_valid_sys,
                   addr_sys, datao_mem,
                   output we_mem, ce_mem, addr_mem,
                   datai_mem, ready_sys, ref data_sys);
  //=================================================
  // Modport for memory interface
  //=================================================
  modport  memory (input clk,reset,we_mem, ce_mem,
                   addr_mem, datai_mem, output datao_mem);
  //=================================================
  // Modport for testbench
  //=================================================
  modport  tb (input clk, ready_sys,
               output reset,we_sys, cmd_valid_sys, addr_sys,
              ref data_sys);

endinterface

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Memory Model
//+++++++++++++++++++++++++++++++++++++++++++++++++
module memory_model (mem_if.memory mif);
// Memory array
logic [7:0] mem [0:255];

//=================================================
// Write Logic
//=================================================
always @ (posedge mif.clk)
 if (mif.ce_mem && mif.we_mem) begin
   mem[mif.addr_mem] <= mif.datai_mem;
 end

//=================================================
// Read Logic
//=================================================
always @ (posedge mif.clk)
 if (mif.ce_mem && ~mif.we_mem)  begin
   mif.datao_mem <= mem[mif.addr_mem];
 end

endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Memory Controller
//+++++++++++++++++++++++++++++++++++++++++++++++++
module memory_ctrl (mem_if.system sif);

typedef  enum {IDLE,WRITE,READ,DONE} fsm_t;

fsm_t state;

always @ (posedge sif.clk)
  if (sif.reset) begin
    state         <= IDLE;
    sif.ready_sys <= 0;
    sif.we_mem    <= 0;
    sif.ce_mem    <= 0;
    sif.addr_mem  <= 0;
    sif.datai_mem <= 0;
    sif.data_sys  <= 8'bz;
  end else begin
    case(state)
       IDLE :  begin
         sif.ready_sys <= 1'b0;
         if (sif.cmd_valid_sys && sif.we_sys) begin
           sif.addr_mem   <= sif.addr_sys;
           sif.datai_mem  <= sif.data_sys;
           sif.we_mem     <= 1'b1;
           sif.ce_mem     <= 1'b1;
           state          <= WRITE;
         end
         if (sif.cmd_valid_sys && ~sif.we_sys) begin
           sif.addr_mem   <= sif.addr_sys;
           sif.datai_mem  <= sif.data_sys;
           sif.we_mem     <= 1'b0;
           sif.ce_mem     <= 1'b1;
           state          <= READ;
         end
       end
       WRITE : begin
         sif.ready_sys  <= 1'b1;
         if (~sif.cmd_valid_sys) begin
           sif.addr_mem   <= 8'b0;
           sif.datai_mem  <= 8'b0;
           sif.we_mem     <= 1'b0;
           sif.ce_mem     <= 1'b0;
           state          <= IDLE;
         end
       end
       READ : begin
         sif.ready_sys  <= 1'b1;
         sif.data_sys   <= sif.datao_mem;
         if (~sif.cmd_valid_sys) begin
           sif.addr_mem   <= 8'b0;
           sif.datai_mem  <= 8'b0;
           sif.we_mem     <= 1'b0;
           sif.ce_mem     <= 1'b0;
           sif.ready_sys  <= 1'b1;
           state          <= IDLE;
           sif.data_sys   <= 8'bz;
         end
       end
    endcase
  end

endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
// Test  program
//+++++++++++++++++++++++++++++++++++++++++++++++++
program test(mem_if.tb tif);

   initial begin
      tif.reset <= 1;
      tif.we_sys <= 0;
      tif.cmd_valid_sys <= 0;
      tif.addr_sys <= 0;
      tif.data_sys <= 8'bz;
      #100 tif.reset <= 0;
      for (int i = 0; i < 4; i ++) begin
         @ (posedge tif.clk);
         tif.addr_sys <= i;
         tif.data_sys <= $random;
         tif.cmd_valid_sys <= 1;
         tif.we_sys <= 1;
         @ (posedge tif.ready_sys);
         $display("@%0dns Writing address %0d with data %0x",
             $time, i,tif.data_sys);
         @ (posedge tif.clk);
         tif.addr_sys <= 0;
         tif.data_sys <= 8'bz;
         tif.cmd_valid_sys <= 0;
         tif.we_sys <= 0;
      end
      repeat (10) @ (posedge tif.clk);
      for (int i= 0; i < 4; i ++) begin
         @ (posedge tif.clk);
         tif.addr_sys <= i;
         tif.cmd_valid_sys <= 1;
         tif.we_sys <= 0;
         @ (posedge tif.ready_sys);
         @ (posedge tif.clk);
         $display("@%0dns Reading address %0d, Got data %0x",
           $time, i,tif.data_sys);
         tif.addr_sys <= 0;
         tif.cmd_valid_sys <= 0;
      end
      #10 $finish;
   end

endprogram

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Testbench
//+++++++++++++++++++++++++++++++++++++++++++++++++
module modport_if();

logic clk = 0;
always #10 clk++;
//=================================================
// Instianciate Interface and DUT
//=================================================
mem_if miff(clk);
memory_ctrl U_ctrl(miff);
memory_model U_model(miff);
test   U_test(miff);

endmodule
