addi $t0, $t0, 1 #soma 1 em t0
addi $t1, $t1, 10 #soma 10 em t1
nop
nop
nop
beq $t0, $t1, ignorar #testa se t0==t1 (não pula pra "ignorar")
nop
nop
nop
sub $t0, $t1, $t0 #faz t0=t1-t0 (10-1)
nop
nop
nop
ignorar: add $t0, $t1, $t0 #faz t0=t1+t0 (10-9)
#
#estado final deveria ser:
#t0=1
#t1=10