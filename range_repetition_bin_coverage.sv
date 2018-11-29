module range_repetition_bin_coverage();

logic [2:0] addr;
reg ce;

covergroup address_cov () @ (posedge ce);
  ADDRESS : coverpoint addr {
    bins adr0[]          = (0[*1:4]);
    bins adr1[]          = (1[*1:2]);
  }
endgroup

address_cov my_cov = new();

initial begin
  ce   <= 0;
  $monitor("ce %b addr 8'h%x",ce,addr);
  repeat (10) begin
    ce <= 1;
    addr <= $urandom_range(0,1);
    #10;
    ce <= 0;
    #10;
  end
end

endmodule
