//=================================================
// Include all the files
//=================================================
`include "msgPkg.sv"
`include "typedefPkg.sv"
//=================================================
// Import the Packages
//=================================================
import msgPkg::*;
import typedefPkg::bool;

//+++++++++++++++++++++++++++++++++++++++++++++++++
// DUT Using the package
//+++++++++++++++++++++++++++++++++++++++++++++++++
module package_call();

bool   value = typedefPkg::FALSE;

initial begin
  msgPkg::initMsgPkg("PACKAGES",0);
  msgPkg::msg_info("Testing Packages");
  #10 msgPkg::msg_warn("Testing Packages");
  #10 msgPkg::msg_error("Testing Packages");
  msgPkg::msg_info($psprintf("Warning Count %0d, Error Count %0d",
   msgPkg::getWarnCnt(), msgPkg::getErrCnt()));
  if (value != typedefPkg::TRUE)  
    #10 msgPkg::msg_fatal("Value is FALSE");
end

endmodule
