# STALL ADD
addi $t0,$t0,10		# adiciona 10 a t0
lw $t1,($t0)		# carrega t0 em t1
add $t0,$t0,$t1		# stall aqui, pois a instrução de load de t1 não finalizou. t0 = t0 + t1
sw $t0,($t2)		# guarda t0 em t2
#
# no final teremos:
# t0 = 20;
# t1 = 10;
# t2 = 20;
