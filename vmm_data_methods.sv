//data methods
function new(vmm_log log);
function vmm_log set_log(vmm_log log);
function void display(string prefix = "");
virtual function string psdisplay(string prefix = "");
virtual function bit is_valid(bit silent = 1, int kind = -1);
virtual function vmm_data allocate();
virtual function vmm_data copy(vmm_data to = null);
virtual protected function void copy_data(vmm_data to);
virtual function bit compare( vmm_data to, output string diff,
   input int kind = -1);
virtual function int unsigned byte_size(int kind = -1);
virtual function int unsigned max_byte_size(int kind = -1);
virtual function int unsigned byte_pack(ref logic [7:0]bytes[],
  input int unsigned offset = 0, input int kind = -1);
virtual function int unsigned byte_unpack(const ref logic [7:0] bytes[],
 input int unsigned offset = 0, input int len= -1, input int kind = -1);
virtual function bit load(int file);
virtual function void save(int file);
