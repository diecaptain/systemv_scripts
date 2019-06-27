`uvm_analysis_imp_decl(_reference_0);
// .........
`uvm_analysis_imp_decl(_reference_n);

class reference extends uvm_component;
  `uvm_component_utils(reference)
  
  uvm_analysis_imp_reference_0 #(input_tx, reference) analysis_export_0;
  // .........
  uvm_analysis_imp_reference_n #(input_tx, reference) analysis_export_n;
  
  uvm_analysis_port #(uvm_sequence_item) analysis_port_0;
  // .........
  uvm_analysis_port #(uvm_sequence_item) analysis_port_n;
  
  // write method of reference model
  function void reference::write_reference_0(input_tx t);
    send(t);
  endfunction
  
  // .........
  
  function void reference::write_reference_n(input_tx t);
    send(t);
  endfunction
  
  // send method of reference model
  function void reference::send(input_tx t);
    output_tx tx;
    tx = output_tx::type_id::create("tx");
    tx.portA = t.portA;
    tx.portB = t.portB;
    case (t.portA % n)
      0: analysis_port_0.write(tx);
      //.........
      n: analysis_port_n.write(tx);
    endcase
    
    `uvm_info(get_type_name(),
              $sformatf("portA = %0d, portB = %0d", t.portA, t.portB), UVM_HIGH);
    
  endfunction
  
  extern function new(string name, uvm_component parent);
  
  extern function void write_reference_0(input input_tx t);
  // ..........
  extern function void write_reference_n(input input_tx t);
  
  // heavy lifting
  extern function void send(input_tx t);
  
endclass: reference
