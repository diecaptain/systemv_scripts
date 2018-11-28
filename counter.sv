//=================================================
// Module declration
//=================================================
module counter(input clk,enable,reset,
output logic [3:0] data);

  always @ (posedge clk)
    if (reset) data <= 0;
    else if (enable) data ++;

endmodule
