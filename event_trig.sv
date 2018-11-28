program event_trig;
  event try_event;
  event get_event;

  initial begin
    // Start the wait_event as parallel thread
    fork
      wait_event();
    join_none

    // Wait till task wait_event has started execution
    $write("Waiting for event get_event\n");
    @ (get_event);
    $write("Triggering event try_event\n");
    #1;
    -> try_event;
    // Wait till task wait_event has done execution
    $write("Waiting for event get_event\n");
    wait (get_event.triggered);
    $write("Got event get_event\n");
    #10 $finish;
  end

  // Task which triggers/waits for events
  task wait_event();
    begin
      #1;
      // Inform that wait_event has started
      $write("--task : Triggering event get_event\n");
      -> get_event;
      $write("--task : Waiting for event try_event\n");
      @(try_event);
      $write("--task : Got event try_event\n");
      // Inform that wait_event has done with execution
      #1;
      $write("--task : Triggering event get_event\n");
      ->get_event;
    end
  endtask

endprogram
