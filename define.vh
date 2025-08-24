parameter INSTR_DEPTH = 2**12;
parameter INSTR_ADDRW = $clog2(INSTR_DEPTH);
parameter INSTR_SIZE = 32;
parameter WORD_SIZE = 16;
parameter REG_ADDRW = 3;
parameter DMEM_DEPTH = 2048;
parameter DMEM_ADDRW = $clog2(DMEM_DEPTH);