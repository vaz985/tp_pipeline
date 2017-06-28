addi $t0, $t0, 1 #soma 1 em t0
addi $t1, $t1, 2 #soma 2 em t1
addi $t2, $t2, 3 #soma 3 em t2
nop
nop
nop
add $t1, $t1, $t2 #soma t1+t2 e guarda em t1
nop
nop
nop
add $t0, $t0, $t1 #soma t0+t1 e guarda em t0
#
#estado final deveria ser:
#t0=6
#t1=5
#t2=3
