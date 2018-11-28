program distribution;
  class frame_t;
    rand bit [7:0] src_port;
    rand bit [7:0] des_port;
    rand bit [15:0] length;
    constraint len {
      length dist {
        [64  :  127 ] := 10,
        [128 :  511 ] := 10,
        [512 :  2048] := 10
      };
    }
    constraint src {
      src_port dist {
        0  := 1,
        1  := 1,
        2  := 5,
        4  := 1
      };
    }
    constraint des {
      des_port dist {
        [0   : 5   ] :/ 5,
        [6   : 100 ] := 1,
        [101 : 200 ] := 1,
        [201 : 255 ] := 1
      };
    }

    function void post_randomize();
      begin
        $display("src port : %0x",src_port);
        $display("des port : %0x",des_port);
        $display("length   : %0x",length);
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
