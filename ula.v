module ula(
	input[31:0] IR,
	input[31:0] in_1,
	input[31:0] in_2,
	input[31:0] in_immediate,
	output reg[31:0] saida,
	output reg[9:0] mem_dest,
	
	input reset,
	input[31:0] m_IR,
	input[31:0] w_IR,
	input[31:0] saidaULA_mm,
	input[31:0] saidaULA_wb
);

reg[2:0] SB [31:0];


always@(IR, m_IR, w_IR, in_1, in_2, in_immediate, reset) begin
  if(reset == 1) begin
    SB[0] <= 0;
	 SB[1] <= 0;
	 SB[2] <= 0;
	 SB[3] <= 0;
	 SB[4] <= 0;
	 SB[5] <= 0;
	 SB[6] <= 0;
	 SB[7] <= 0;
	 SB[8] <= 0;
	 SB[9] <= 0;
	 SB[10] <= 0;
	 SB[11] <= 0;
	 SB[12] <= 0;
	 SB[13] <= 0;
	 SB[14] <= 0;
	 SB[15] <= 0;
    SB[16] <= 0;
	 SB[17] <= 0;
	 SB[18] <= 0;
	 SB[19] <= 0;
	 SB[20] <= 0;
	 SB[21] <= 0;
	 SB[22] <= 0;
	 SB[23] <= 0;
	 SB[24] <= 0;
	 SB[25] <= 0;
	 SB[26] <= 0;
	 SB[27] <= 0;
	 SB[28] <= 0;
	 SB[29] <= 0;
	 SB[30] <= 0;
	 SB[31] <= 0;
  end
  
  
 
  // ADDI CLEAN
  if( w_IR[31:26] == 6'b001000 ) begin
    SB[w_IR[20:16]] <= 00;
  end

  //next stage
  if( m_IR[31:26] == 6'b001000 ) begin
    SB[m_IR[20:16]] <= 10;
  end
  
  
  
  if ( IR[31:26] == 6'b000000 ) begin
    //add
    if( IR[5:0] == 6'b100000 ) begin
      mem_dest <= 0;
	   saida <= in_1 + in_2;
    end
    //sub
    else if( IR[5:0] == 6'b100010 ) begin
      mem_dest <= 0;
		saida <= in_1 - in_2;
    end
  end
  // addi
  else if( IR[31:26] == 6'b001000 ) begin
    if( SB[IR[25:21]] == 01 ) begin
	   saida <= saidaULA_mm + in_immediate;  
	 end
	 else
	 if( SB[IR[25:21]] == 10 ) begin
	   saida <= saidaULA_wb + in_immediate;
	 end
	 else begin
	   saida <= in_1 + in_immediate;
	 end
    SB[IR[20:16]] <= 01;
	 mem_dest <= 0;
  end
  //load
  else if( IR[31:26] == 6'b100011 ) begin
    mem_dest <= IR[20:16];
	 saida <= in_1 + in_immediate;
  end
  //store
  else if( IR[31:26] == 6'b101011 ) begin
    mem_dest <= in_1 + in_immediate;
	 saida <= in_2;
  end
end

endmodule