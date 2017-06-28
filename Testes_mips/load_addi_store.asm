addi $t0, $t0, 1 #soma 1 em t0
nop
nop
nop
lw $t1, ($t0) #carrega t0 em t1
nop
nop
nop
addi $t1, $t1, 1 #soma 1 em t1
nop
nop
nop
sw $t1, ($t0) #guarda t1 em t0
#
#estado final deveria ser:
#t0=2
#t1=2
#!!(não sei se fiz a lógica do store certa, da uma olhada ai)