`ifndef EXTERN_CLASS_BODY_SV
`define EXTERN_CLASS_BODY_SV

`include "extern_class_header.svi"

function extern_class::new();
  this.address = $random;
  this.data = {$random,$random};
  this.crc  = $random;
endfunction

task extern_class::print();
  $display("Address : %x",address);
  $display("Data    : %x",data);
  $display("CRC     : %x",crc);
endtask

`endif
