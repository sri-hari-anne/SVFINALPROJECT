import mc_package::*;

module Processor(
    output logic [ADDRWIDTH-1:0] Addr,
    output logic [DATAWIDTH-1:0] WrData,
    output logic Rd_Wr,
    output logic valid,
    input logic [DATAWIDTH-1:0] RdData,
    input logic Ready
);

parameter INPUTFILE = "testcases.txt";

typedef struct packed {
  int ClockTicks;                       //
  logic Operation;                      //
  logic [ADDRWIDTH-1:0] Address;        //
  logic [DATAWIDTH-1:0] Data;           //
} TestCase;

TestCase Associative_Memory[$];         //Declaration of Associative memory 
int index = 1;                          //Index for the associative memory

integer InFile;                         //File Descriptor
int linecount = 0;                      //Line Count for displaying when line reading fails (incomplete data length)

int ClockTickCount = 0;                 // variable to store current clocktick count value


initial                                 //Generate free running clock
	forever #5 Clock = ~Clock;


initial  
begin
  InFile = $fopen(INPUTFILE, "r");      // Open the testcase file
  if (InFile == 0) 
  begin
    $display("***ERROR***Can't open inputfile %s", INPUTFILE);
    $finish(); 
  end

  // While loop to read all the file lines and put them in Associative Memory
  while (!$feof(InFile)) 
  begin
    TestCase TC;
	  linecount++;
    if ($fscanf(InFile, "%d %b %h %h", TC.ClockTicks, TC.Operation, TC.Address, TC.Data) == 4) 
    begin
      Associative_Memory.push_back(TC);
      //$display("Struct Contents (read from file) :: ClockTicks=%d, Operation=%b, Address=%h, Data=%h", TC.ClockTicks, TC.Operation, TC.Address, TC.Data);
    end
    else
    begin
      $display("***Incomplete Data - Line reading failed at Line Number %d***", linecount);
    end
  end
  
    $fclose(InFile);                      // Close the testcase file
  
  // // Print the contents of the Associative_Memory
  //     $display("\n Display Associative_Memory Contents:");
  // foreach (Associative_Memory[i]) 
  // begin
	// //$display("Associative_Memory[%d]: %d", i, Associative_Memory[i]);
	// $display("Associative_Memory[%0d]: ClockTicks = %d, Operation = %b, Address = %h, Data = %h", i, Associative_Memory[i].ClockTicks, Associative_Memory[i].Operation, Associative_Memory[i].Address, Associative_Memory[i].Data);
  // end
  
int index = 0;

always @(posedge Clock)
begin
  ClockTickCount++;    
end

always @(posedge Clock)
begin
  //read first line from associative memory and put them into local variables.
  ClockTicks  = Associative_Memory[index].ClockTicks;
  Operation   = Associative_Memory[index].Operation;
  Address     = Associative_Memory[index].Address;
  Data        = Associative_Memory[index].Data;


 if (ClockTickCount === ClockTicks)
	 begin

		if (Operation = 0 && Ready == 1) //Read
    begin
        // read from memory controller (how?) 
        Addr    = Address;
        Rd_Wr   = Operation;
        valid   = TRUE;
        
        While (Ready = 1)
        if(Data === RdData)
        $display("Data Read Successful, Matching with the data in associative memory");


        

        // Check if it is present in your assocaiative memory. 
        // If present, it should be the same data value.

    end

		else if (Operation = 1 && Ready == 1) //Write
    begin
      	// If write, generate data and store that data and address to the assocaiative memory 
        // send the address, data and operation type to memory Controller(How do we send requests to Memory Controller?)
        Addr    = Address;
        Rd_Wr   = Operation;
        WrData  = Data;
        valid   = 1;


		
    end

    index++;
	 end
	 
 else
	 begin
		//Wait for one Clock Cycle
	 end
 end


  $finish();
end

endmodule