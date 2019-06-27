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
  
  extern function new(string name, uvm_component parent);
  
  extern function void write_reference_0(input input_tx t);
  // ..........
  extern function void write_reference_n(input input_tx t);
  
endclass: reference
