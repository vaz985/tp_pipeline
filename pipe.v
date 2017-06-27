module mips_pipeline(

	input			CLOCK_50,// Para a placa
	input[3:0]		   KEY,
	output[31:0] out_valor1,
	output[31:0] out_valor2,
	output[31:0] out_valor3,
	output[8:0]		LEDG, // Para a placa
	output[0:6]		HEX0, // Para a placa
	output[0:6]		HEX1, // Para a placa
	output[0:6]		HEX2, // Para a placa
	output[0:6]		HEX3, // Para a placa
	output[0:6]		HEX4, // Para a placa
	output[0:6]		HEX5, // Para a placa
	output[0:6]		HEX6, // Para a placa
	output[0:6]		HEX7 // Para a placa
);

reg [31:0] clk;

// incrementado o contador clk em função do CLOCK_50 (clock de 50 Mhz interno da placa)
always@(posedge CLOCK_50)begin
	clk = clk + 1;
end

wire clock = clk[24];

reg [9:0] PC; // Contador de programa do MIPS
reg [9:0] PC_decode;
reg [9:0] PC_execute;


reg[31:0] decode_IR;
reg[31:0] execute_IR;
reg[31:0] memory_IR;
reg[31:0] wback_IR;

reg[4:0]  ex_dest;
reg[31:0] ex_immediate;
	
reg[31:0] mem_saidaULA;
reg[4:0]  mem_dest;
reg[31:0] mem_b;


reg halt;

wire [31:0] out_mem_inst; //saída da memória de instruções
wire [31:0] out_mem_data; //saída da memória de dados


reg      jump_enable;
reg[9:0] jump_dest;

wire rst;

// instanciando a memória de instruções (ROM)
mem_inst mem_i(
.address(PC),    //Endereco da instrucao
.clock(clock),    
.q(out_mem_inst) //Saida da instrucao
);



// MEMORIA DE DADOS
wire signal_wren;

assign signal_wren = ( memory_IR[31:26] == 6'b101011 ) ? 1 : 0 ;

mem_data mem_d(
.address(mem_saidaULA[9:0]), //Endereco do dado
.clock(clock), 
.data(mem_b),       //Dado escrito
.wren(signal_wren), //Switch de escrita
.q(out_mem_data)    //Dado de saida 
);


// BANCO DE REGISTRADORES 2.0
wire [31:0] dado_lido_1; // dado lido do banco de registardores
wire [31:0] dado_lido_2; // dado lido do banco de registardores

wire[4:0] rs_in;
wire[4:0] rt_in;
wire[4:0] rd_in;

wire[31:0] wb_write;
wire[4:0]  wb_dest;
wire wb_enable;

assign rs_in = decode_IR[25:21];
assign rt_in = (decode_IR[31:26] == 6'b001000 || decode_IR[31:26] == 6'b100011) ? decode_IR[20:16] : decode_IR[15:11];

assign wb_enable = ( 
(memory_IR[31:26] == 6'b000000 && ( memory_IR[31:26] == 6'b100000 || memory_IR[31:26] == 6'b100010) )
|| 
(memory_IR[31:26] == 6'b001000)
|| 
(memory_IR[31:26] == 6'b100011)
) 
? 1 : 0 ;

assign wb_dest  = ( memory_IR[31:26] == 6'b001000 || memory_IR[31:26] == 6'b100011)  ? memory_IR[20:16] : memory_IR[15:11];
assign wb_write = ( wb_enable == 1) ? (( memory_IR[31:26] == 6'b000000 || memory_IR[31:26] == 6'b001000 ) ? mem_saidaULA : out_mem_data ) : 0; 


banco_de_registradores br(
.reset(rst),

.br_out_R_rs(dado_lido_1), // A
.br_out_R_rt(dado_lido_2),	// B

.br_in_rs_decode(rs_in), //RS
.br_in_rt_decode(rt_in), //RT

.wb_enable(wb_enable),  //Switch de escrita
.br_in_data(wb_write),  //Dado escrito
.br_in_dest_wb(wb_dest)	//Registrado destino
); 


// DECODE
wire[31:0] ex_a;
wire[31:0] ex_b;

assign ex_a = (
( execute_IR[31:26] == 6'b000000 && ( execute_IR[5:0] == 6'b100000 || execute_IR[5:0] == 6'b100010 ) )
||
( execute_IR[31:26] == 6'b001000 )
||
( execute_IR[31:26] == 6'b100011 )
||
( execute_IR[31:26] == 6'b101011 )
)
? dado_lido_1 : 0 ;

assign ex_b = 
( execute_IR[31:26] == 6'b000000 && ( execute_IR[5:0] == 6'b100000 || execute_IR[5:0] == 6'b100010 ) ) 
? dado_lido_2 : 0 ;

//

assign LEDG[0] = clock;

assign rst = ( KEY[0] == 0 ) ? 1 : 0 ;

// Controlador de escrita da memoria de dados
  
always@(posedge clock) begin
  if(rst == 1'b1) begin
    decode_IR  <= 32'b0;
    execute_IR <= 32'b0;
    memory_IR  <= 32'b0;
    wback_IR   <= 32'b0;
	 halt       <= 1'b1;
	 PC         <= 10'b0;
  end
  else begin
    if(halt == 1'b1) begin
		  halt <= 1'b0;
		  PC <= PC + 1;
    end	
    else begin
		// Jump/Beq
	   if(jump_enable == 1) begin
		  PC <= jump_dest;
		  jump_dest <= 10'b0;
		  jump_enable <= 0;
		  decode_IR <= out_mem_inst;
		  PC_decode <= PC;	
	   end
		// Fetch -> Decode
	   else begin
		  PC <= PC + 1;
		  decode_IR <= out_mem_inst;
		  PC_decode <= PC;  
      end
    end
  

  //
  //Decode -> Execute

  ex_immediate <= {{16{decode_IR[15]}}, decode_IR[15:0]};
  execute_IR <= decode_IR; 
  PC_execute <= PC_decode;
  
  //Fim Decode -> Execute
  //
  //Execute -> Memory
  if ( execute_IR[31:26] == 6'b000000 ) begin
    //add
    if ( execute_IR[5:0] == 6'b100000 ) begin
      mem_saidaULA <= ex_a + ex_b;
    end
    //sub
    else if ( execute_IR[5:0] == 6'b100010 ) begin
      mem_saidaULA <= ex_a - ex_b;
    end
  end
  // addi
  else if ( execute_IR[31:26] == 6'b001000 ) begin
    mem_saidaULA <= ex_a + ex_immediate;
  end
  //load
  else if( execute_IR[31:26] == 6'b100011 ) begin
    mem_saidaULA <= ex_a + ex_immediate;
  end
  //stori
  else if( execute_IR[31:26] == 6'b101011 ) begin
    mem_saidaULA <= ex_a + ex_immediate;
    mem_b <= ex_b;
  end
  //jump
  else if( execute_IR[31:26] == 6'b000010 ) begin
    jump_dest <= execute_IR[9:0];
	 jump_enable <= 1;
  end
  //beq
  else if( execute_IR[31:26] == 6'b000100 && (ex_a == ex_b) ) begin
    jump_dest <= PC_execute + ex_immediate[9:0];
    jump_enable <= 1;
  end  
  memory_IR <= execute_IR;
  //Fim Execute -> Memory
  //
  //Memory -> WriteBack
  wback_IR <= memory_IR;	
  //Fim Memory -> WriteBack
  
  // Limpador
  if( jump_enable == 1 ) begin
    decode_IR  <= 0;
	 execute_IR <= 0;
  end
  end
//Fim do always
end
  
endmodule
