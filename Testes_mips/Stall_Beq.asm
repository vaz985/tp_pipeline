# STALL BEQ
addi $t0,$t0,10		# adiciona 10 a t0
lw $t1,($t0)		# carrega t0 em t1
beq $t0,$t1, label	# stall aqui, pois a instrução de load de t1 não finalizou. Pula pra label
add $t0,$t1,$t1		# soma t1 com t1 e guarda em t0. t0 = t1 + t1 SE CORRETO, NÃO DEVE SER FEITO
label: addi $t0, $t0, 50	#se pulou certo, soma t0 a 50 e guarda em t0. t0 = t0 + 50
sw $t0,($t2)		# guarda t0 em t2
#
# no final teremos:
# t0 = 60;
# t1 = 10;
# t2 = 60;
