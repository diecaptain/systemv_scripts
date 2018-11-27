module cast();

typedef enum {IDLE,SFD,PREAMBLE,
              DATA,FCS,EFD} eth_state;

eth_state fsm;

initial begin
 #5 fsm = IDLE;
 $display("@%0dns Current value of FSM : %s\n",
    $time,get_name(fsm));
 #5 fsm = SFD;
 $display("@%0dns Current value of FSM : %s\n",
    $time,get_name(fsm));
 #1 $cast(fsm,1+2);
 $display("@%0dns Current value of FSM : %s\n",
    $time,get_name(fsm));
 // Below line should give compile error
 //fsm = 2 + 1;
end

eth_state temp;
eth_state temp2;
integer i ;

initial begin
  #20;
  for(i = 0; i <= 5; i++) begin
    $cast(temp,i);
    $display("Value of temp is %s",
         get_name(temp.next()));
  end
end

function string get_name;
  input eth_state lstate;
  case(lstate)
    IDLE     : get_name = "IDLE";
    SFD      : get_name = "SFD";
    PREAMBLE : get_name = "PREAMBLE";
    DATA     : get_name = "DATA";
    FCS      : get_name = "FCS";
    EFD      : get_name = "EFD";
  endcase
endfunction

endmodule
