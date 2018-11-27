module class_data();

// Class with local fields
class Packet;
  int address;
  bit [63:0] data;
  shortint crc;
endclass:Packet

// Class with task
class print;
  task print_io (input string msg);
    $display("%s",msg);
  endtask:print_io
endclass:print

// Create instance
Packet p;
print  prn;

initial begin
  // Allocate memory
  p = new();
  prn = new();
  // Assign values
  p.address = 32'hDEAD_BEAF;
  p.data = {4{16'h55AA}};
  p.crc  = 0;
  // Print all the assigned values
  $display("p.address = %d p.data = %h p.crc = %d",
    p.address, p.data, p.crc);
  prn.print_io("Test calling task inside class");
  $finish;
end

endmodule
