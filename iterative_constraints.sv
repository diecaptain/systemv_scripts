program iterative_constraints;
  class frame_t;
    rand bit zero;
    rand bit [15:0] data [];

    constraint frame_sizes {
      solve zero before data.size;
      zero -> data.size == 0; 
      data.size inside {[1:10]};
      foreach (data[i])
        data[i] == i;
    }
    function void post_randomize();
      begin
        $display("length   : %0d", data.size());
        for (integer i = 0; i < data.size(); i++) begin
         $write ("%2x ",data[i]);
        end
        $write("\n");
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
