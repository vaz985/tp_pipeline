j label1 #pula direto pra label1
addi $t0, $t0, 1 #se o jump de cima der pau soma 1 em t0 e 2 em t1
addi $t1, $t1, 2
nop
nop
nop
label1: beq $t0, $t1, label2 #se t0 e t1 ainda forem 0 pula pra label2
nop
nop
nop
addi $t0, $t0, 10 #se o beq de cima der pau soma 10 em t0 e 20 em t1
addi $t1, $t1, 20
label2: addi $t3, $t3, 5 #soma 5 em t3 (essa deveria ser a unica soma feita)
#
#estado final deveria ser:
#t0=0
#t1=0
#t3=5