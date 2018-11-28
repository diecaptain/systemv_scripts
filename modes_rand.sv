program modes_rand;
  class frame_t;
    rand bit [7:0] src_addr;
    rand bit [7:0] dst_addr;
    constraint c {
    src_addr <=  127;
    dst_addr >=  128;
    }
    task do_randcase();
      begin
        randcase
        30 :  function void pre_randomize();
                begin
                  $write("pre_randomize  : Value of Source      address  %2x\n",src_addr);
                  $write("pre_randomize  : Value of Destination address  %2x\n",dst_addr);
                end
              endfunction
        30 :  function void post_randomize();
                begin
                  $write("post_randomize  : Value of Source      address  %2x\n",src_addr);
                  $write("post_randomize  : Value of Destination address  %2x\n",dst_addr);
                end
              endfunction
        40 :  task print();
                begin
                  $write("Source      address %2x\n",src_addr);
                  $write("Destination address %2x\n",dst_addr);
                end
              endtask
        endcase
      end
    endclass
    function void pre_randomize();
      begin
        $write("pre_randomize  : Value of Source      address  %2x\n",src_addr);
        $write("pre_randomize  : Value of Destination address  %2x\n",dst_addr);
      end
    endfunction
    function void post_randomize();
      begin
        $write("post_randomize  : Value of Source      address  %2x\n",src_addr);
        $write("post_randomize  : Value of Destination address  %2x\n",dst_addr);
      end
    endfunction
    task print();
      begin
        write("Source      address %2x\n",src_addr);
        $write("Destination address %2x\n",dst_addr);
      end
    endtask

  initial begin
    frame_t frame = new();
    integer j = 0;
    repeat (10) begin
    $write("-------------------------------\n");
    $write("Picking random randomize function with randcase\n");
    j = frame.do_randcase();
    frame.print();
    $write("-------------------------------\n");
    $write("With Pre Randomized value\n");
    j = frame.pre_randomize();
    frame.print();
    $write("-------------------------------\n");
    $write("With Post Randomized value\n");
    j = frame.post_randomize();
    frame.print();
    $write("-------------------------------\n");
    $write("Without Randomize Value\n");
    frame.print();
    $write("-------------------------------\n");
    $write("With Randomize Value\n");
    j = frame.randomize();
    frame.print();
    $write("-------------------------------\n");
    $write("With Randomize OFF and Randomize\n");
    frame.rand_mode(0);
    j = frame.randomize();
    frame.print();
    $write("-------------------------------\n");
    $write("With Randomize ON and Randomize\n");
    frame.rand_mode(1);
    j = frame.randomize();
    frame.print();
    $write("-------------------------------\n");
    $write("With Randomize OFF on dest addr and Randomize\n");
    frame.dst_addr.rand_mode(0);
    j = frame.randomize();
    frame.print();
    $write("-------------------------------\n");
    $write("-------------------------------\n");
    $write("Randomize with Value\n");
    j = frame.randomize() with {
    src_addr > 100;
    dst_addr < 130;
    dst_addr > 128;
    };
    frame.print();
    $write("-------------------------------\n");
  end
endprogram
