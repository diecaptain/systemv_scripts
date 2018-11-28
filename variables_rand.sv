typedef enum { UNICAST=11, MULTICAST, BROADCAST} pkt_type;

program variables_rand;
  class frame_t;
    rand pkt_type ptype;
    rand integer len;
    randc bit [1:0] no_repeat;
    rand bit  [7:0] payload [];
    // Constraint the members
    constraint legal {
      len >= 2;
      len <= 5;
      payload.size() == len;
    }
    function string getType(pkt_type ltype);
      begin
        case(ltype)
         UNICAST   : getType = "UNICAST";
         MULTICAST : getType = "MULTICAST";
         BROADCAST : getType = "BROADCAST";
         default   : getType = "UNKNOWN";
        endcase
      end
    endfunction
    // Print the members of the class
    task print();
      begin
        integer i =0;
        $write("Packet type %s\n",getType(ptype));
        $write("Size of frame is %0d\n",len);
        if (payload.size() > 0) begin
          $write("Payload is ");
          for (i=0; i < len; i++) begin
            $write(" %2x",payload[i]);
          end
          $write("\n");
        end
        $write("no_repeat is %d\n",no_repeat);
      end
    endtask
  endclass

  initial begin
    frame_t frame = new();
    integer j = 0;
    // Print frame before randomize
    $write("-------------------------------\n");
    frame.print();
    $write("-------------------------------\n");
    for (j = 0 ; j < 10;j++) begin
      if (frame.randomize() == 1) begin
        // Print frame after randomize
        frame.print();
      end else begin
        $write("Failed to randomize frame\n");
      end
      $write("-------------------------------\n");
    end
  end
endprogram
