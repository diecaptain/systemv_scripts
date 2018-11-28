program set_membership;
  class frame_t;
    rand bit [7:0] src_port;
    rand bit [7:0] des_port;
    constraint c {
       // inclusive
       src_port inside { [8'h0:8'hA],8'h14,8'h18 };
       // exclusive
       !(des_port inside { [8'h4:8'hFF] });
    }
    function void post_randomize();
      begin
        $display("src port : %0x",src_port);
        $display("des port : %0x",des_port);
      end
    endfunction
  endclass

  initial begin
    frame_t frame = new();
    integer i,j = 0;
    for (j=0;j < 4; j++) begin
      $display("-------------------------------");
      $display("Randomize Value");
      $display("-------------------------------");
      i = frame.randomize();
    end
    $display("-------------------------------");
  end
endprogram
