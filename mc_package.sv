package mc_package;

parameter ADDRWIDTH=32;
parameter DATAWIDTH=64;
parameter ROW_WIDTH = 15;
parameter COL_WIDTH = 10;
parameter NUMBER_OF_BANKS = 4;
parameter BANK_GROUPS = 4; // 4 bank groups each group has 4 banks
parameter BANKS = 4;
parameter BUFFER_SIZE = 16;
parameter TRUE = 1'b1;
parameter FALSE = 1'b0;
parameter BURST_INDEX = $clog2(DATAWIDTH);

endpackage