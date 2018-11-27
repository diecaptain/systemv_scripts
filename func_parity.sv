module func_parity ();

parameter width = 8;
parameter val_width = 31;
parameter ref_width = 8;
reg [width:0] data      ;
reg       parity_out_val;
reg       parity_out_ref;
reg       parity_out_name;
reg       parity_out_default;
integer   i         ;
time      ltime;

// Function  using pass by value
function parity_value;
 input [val_width:0] data;
 integer i;
 begin
  parity_value = 0;
  for (i= 0; i < val_width+1; i = i + 1) begin
    parity_value = parity_value ^ data[i];
  end
 end
endfunction

/*// Function using pass by reference
function reg parity_ref;
 ref reg [ref_width:0] idata;
 integer i;
 begin
   parity = 0;
   for (int i= 0; i < ref_width+1; i ++) begin
     parity = parity ^ idata[i];
   end
 end
 // We can modify the data passed through reference
 //idata ++ ;
 // Something that is passed as const  ref, can  not be modified
 // tdata ++ ; This is wrong
endfunction*/

/*// Function using pass by name
function automatic reg parity_name (ref reg [ref_width:0] idata, ref time itime);
 parity = 0;
 for (int i= 0; i < ref_width+1; i ++) begin
    parity = parity ^ idata[i];
 end
 // We can modify the data passed through reference
 idata ++ ;
 // Something that is passed as const  ref, can  not be modified
 // tdata ++ ; This is wrong
endfunction*/

// Function using default value
function reg parity_default (reg [ref_width:0] a, time b = 0, time c = 0);
integer i;
begin
 parity_default = 0;
 for (int i= 0; i < ref_width+1; i ++) begin
    parity_default = parity_default ^ a[i];
 end
end
endfunction

initial begin
  parity_out_val = 0;
  //parity_out_ref = 0;
  //parity_out_name = 0;
  parity_out_default = 0;
  data = 0;
  for (i=500; i<512; i = i + 1) begin
   #5 data = i;
   //ltime = $time;
   // Calling pass by value
   parity_out_val = parity_value (data);
   $display ("Data = %b, Parity_val = %b", data, parity_out_val);

  /* // Calling pass by reference
   parity_out_ref = parity_ref (data);
   $display ("Data = %000000000b, Parity_ref = %b, Modified data : %b", i, parity_out_ref, data);
  */
   /*// Calling pass by name
   parity_out_name = parity_name (.idata(data), .itime(ltime));
   $display ("Data = %00000000b, Parity = %b, Modified data : %b", i, parity_out_name, data);
   */
   // Function returning default value
   parity_out_default = parity_default (data);
   parity_out_default = parity_default (data,,);
   parity_out_default = parity_default (data,,10);
   parity_out_default = parity_default (data,ltime,);
   $display ("Data = %000000000b, Parity_default = %b", data, parity_out_default);

  end
  #10 $finish;
end

endmodule
