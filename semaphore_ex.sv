program semaphore_ex;

  semaphore  semBus = new(10);

  task automatic agent(string name, integer nwait);
    integer i = 0;
    for (i = 0 ; i < 4; i ++ ) begin
      semBus.get(5);
      $display("[%0d] Lock semBus for %s", $time,name);
      #(nwait);
      $display("[%0d] Release semBus for %s", $time,name);
      semBus.put(8);
      #(nwait);
    end
  endtask

  initial begin
    fork
      agent("AGENT 0",5);
      agent("AGENT 1",20);
    join
  end

endprogram
