module explicit_bin_coverage();

logic [7:0] addr;
reg ce;

covergroup address_cov () @ (posedge ce);
  ADDRESS : coverpoint addr {
    // Bins are explicity declared, This is prefered way
    bins low          = {0,10};
    bins med          = {11,20};
    bins value_255    = {255};
    // All other values are not counted in the coverage calculation
    bins lazy         = default;
    // Ignore Bins
    ignore_bins iggy  = {41,49};
    ignore_bins iggy_trans = (5=>25=>125);
    // Illegal bins
    illegal_bins ignore = {83}; 
  }
endgroup

address_cov my_cov = new();

initial begin
  ce   <= 0;
  addr <= 0;
  $monitor("ce %b addr 8'h%x",ce,addr);
  repeat (10) begin
    addr = $random();
    ce <= 1;
    #10;
    ce <= 0;
    #10;
  end
end

endmodule
