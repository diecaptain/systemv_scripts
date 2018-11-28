program mailbox_ex;
  mailbox checker_data  = new();

  initial begin
    fork
      input_monitor();
      checker();
    join_any
    #1000;
  end

  task input_monitor();
    begin
      integer i = 0;
      // This can be any valid data type
      bit [7:0] data = 0;
      for(i = 0; i < 4; i ++) begin
        #(3);
        data = $random();
        $display("[%0d] Putting data : %x into mailbox", $time,data);
        checker_data.put(data);
      end
    end
  endtask

  task checker();
    begin
      integer i = 0;
      // This can be any valid data type
      bit [7:0] data = 0;
      while (1) begin
        #(1);
        if (checker_data.num() > 0) begin
          checker_data.get(data);
          $display("[%0d] Got data : %x from mailbox", $time,data);
        end else begin
          #(7);
        end
      end
    end
  endtask

endprogram
