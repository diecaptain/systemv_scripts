class port_converter #(type T = uvm_sequence_item) extends uvm_subscriber #(T);
  // using uvm component param utilis macro to declare port converter box
  `uvm_component_param_utilis(port_converter#(T))
  // connecting analysis port of monitor to analysis export of scoreboard
  `uvm_analysis_port #(uvm_sequence_item) analysis_port;
  
  // using factory base automation
  function new(string name, uvm_component_parent);
    super.new(name, parent);
    analysis_port = new("a_port", this);
  endfunction
  
  // Implicit up-cast to scoreboard
  function void write(T, t);
    analysis_port.write(t);
  endfunction
  
endclass: port_converter
