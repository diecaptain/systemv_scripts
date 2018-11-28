//+++++++++++++++++++++++++++++++++++++++++++++++++
// Define the interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
interface mem_if (
  input  wire         clk,
  input  wire         reset,
  input  wire         we,
  input  wire         ce,
  input  wire   [7:0] datai,
  output logic  [7:0] datao,
  input  wire   [7:0] addr
);
endinterface

//+++++++++++++++++++++++++++++++++++++++++++++++++
//   DUT With interface
//+++++++++++++++++++++++++++++++++++++++++++++++++
module simple_port_if (mem_if mif);
// Memory array
logic [7:0] mem [0:255];
//=================================================
// Read logic
//=================================================
always @ (posedge mif.clk)
 if (mif.reset) mif.datao <= 0;
 else if (mif.ce && !mif.we) begin
   mif.datao <= mem[mif.addr];
 end
//=================================================
// Write Logic
//=================================================
always @ (posedge mif.clk)
 if (mif.ce && mif.we) begin
   mem[mif.addr] <= mif.datai;
 end

endmodule

//+++++++++++++++++++++++++++++++++++++++++++++++++
//  Testbench
//+++++++++++++++++++++++++++++++++++++++++++++++++
module tb();

logic clk = 0;
always #10 clk++;
logic   reset,ce,we;
logic [7:0] datai,addr;
wire  [7:0] datao;
//=================================================
// Instianciate Interface and DUT
//=================================================
mem_if miff(
 .clk     (clk),
 .reset   (reset),
 .ce      (ce),
 .we      (we),
 .datai   (datai),
 .datao   (datao),
 .addr    (addr)
);

simple_port_if U_dut(.mif (miff));
//=================================================
// Test Vector generation
//=================================================
initial begin
  reset <= 1;
  ce <= 1'b0;
  we <= 1'b0;
  addr <= 0;
  datai <= 0;
  repeat (10) @ (posedge clk);
  reset <= 0;
  for (int i = 0; i < 3; i ++ ) begin
    @ (posedge clk) ce <= 1'b1;
    we <= 1'b1;
    addr <= i;
    datai <= $random;
    @ (posedge clk) ce <= 1'b0;
    $display ("@%0dns Write access address %x, data %x",
      $time,addr, datai);
  end
  for (int i = 0; i < 3; i ++ ) begin
    @ (posedge clk) ce <= 1'b1;
    we <= 1'b0;
    addr <= i;
    repeat (2) @ (posedge clk);
    ce <= 1'b0;
    $display ("@%0dns Read access address %x, data %x",
      $time,addr, datao);
  end
  #10 $finish;
end

endmodule
