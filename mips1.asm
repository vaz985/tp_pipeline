addi $t1,$t1,1
addi $t2,$t2,1
addi $t6,$t6,1
addi $t7,$zero,3
loop: beq $t7,$zero,sai_loop
addi $t0,$t2,0
add $t1,$t1,$t0
add $t2,$t1,$t2
sub $t7,$t7,$t6
j loop
sai_loop:
addi $t0,$zero,0
addi $t1,$zero,0
addi $t2,$zero,0