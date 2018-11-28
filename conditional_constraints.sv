program conditional_constraints;
  class frame_t;
    typedef enum {RUNT,NORMAL,OVERSIZE} size_t;
    rand bit [15:0] length;
    rand size_t size;

    constraint frame_sizes {
      size == NORMAL -> {
        length dist {
          [64  :  127 ] := 10,
          [128 :  511 ] := 10,
          [512 :  1500] := 10
        };
      }
      if (size == RUNT)  {
        length >= 0;
        length <= 63;
      } else if (size == OVERSIZE) {
        length >= 1501;
        length <= 5000;
      }
    }
    function void post_randomize();
      begin
        $display("length   : %0d",length);
        case(size)
          RUNT     : $display ("Frame size_t is RUNT");
          NORMAL   : $display ("Frame size_t is NORMAL");
          OVERSIZE : $display ("Frame size_t is OVERSIZE");
        endcase
      end
    endfunction
  endclass

  initial begin
     frame_t frame = new();
     integer i,j = 0;
     for (j=0;j < 4; j++) begin
       $write("-------------------------------\n");
       $write("Randomize Value\n");
       i = frame.randomize();
     end
     $write("-------------------------------\n");
  end

endprogram
