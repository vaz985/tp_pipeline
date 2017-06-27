module banco_de_registradores(

  input reset,
  // INDEX DOS REGISTRADORES BUSCADOS
  input[4:0] br_in_rs_decode,
  input[4:0] br_in_rt_decode,
  
  output reg[31:0] br_out_R_rs,
  output reg[31:0] br_out_R_rt,

  // DADO Q VAI SER ESCRITO
  input wb_enable,
  input[4:0] br_in_dest_wb,
  input[31:0] br_in_data

  // RETORNA A E B
);

reg [31:0] mem_pos [31:0];

// RESET
always@(wb_enable, reset, br_in_dest_wb) 
begin
  if(reset == 1'b1) begin
    mem_pos[0] <= 32'b0;
    mem_pos[1] <= 32'b0;
    mem_pos[2] <= 32'b0;
    mem_pos[3] <= 32'b0;
    mem_pos[4] <= 32'b0;
    mem_pos[5] <= 32'b0;
    mem_pos[6] <= 32'b0;
    mem_pos[7] <= 32'b0;
    mem_pos[8] <= 32'b0;
    mem_pos[9] <= 32'b0;
    mem_pos[10] <= 32'b0;
    mem_pos[11] <= 32'b0;
    mem_pos[12] <= 32'b0;
    mem_pos[13] <= 32'b0;
    mem_pos[14] <= 32'b0;
    mem_pos[15] <= 32'b0;
    mem_pos[16] <= 32'b0;
    mem_pos[17] <= 32'b0;
    mem_pos[18] <= 32'b0;
    mem_pos[19] <= 32'b0;
    mem_pos[20] <= 32'b0;
    mem_pos[21] <= 32'b0;
    mem_pos[22] <= 32'b0;
    mem_pos[23] <= 32'b0;
    mem_pos[24] <= 32'b0;
    mem_pos[25] <= 32'b0;
    mem_pos[26] <= 32'b0;
    mem_pos[27] <= 32'b0;
    mem_pos[28] <= 32'b0;
    mem_pos[29] <= 32'b0;
    mem_pos[30] <= 32'b0;
    mem_pos[31] <= 32'b0;
    
  end
  else if(wb_enable == 1) begin
    mem_pos[br_in_dest_wb] <= br_in_data;
  end 
end

// ALWAYS DO DECODE
always@(br_in_rs_decode, br_in_rt_decode)
begin
  br_out_R_rs <= mem_pos[br_in_rs_decode];
  br_out_R_rt <= mem_pos[br_in_rt_decode];
end


endmodule