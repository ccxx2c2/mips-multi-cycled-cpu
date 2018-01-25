.data 
length: .word 1
width: .word 2
height: .word 3
cir: .word 0
.word 0
.word 0
.word 0
.word -1
.text
main:
lw $t1,0
lw $t2,1
lw $t3,2
lw $t4,4
and $t5,$t2, $t3
or $t5,$t2, $t3
xor $t5,$t2, $t3
nor $t5,$t2, $t3
addiu $t5, $zero, 4
andi $t5,$t2,7
ori $t5,$t2,7
xori $t5,$t2,7
slti $t5, $t2, 0# 2 > 0 , t5 = 0
sltiu $t5, $t2, -2 # 2 < ffffffe , t5 = 1
sltiu $t5, $t2, 2 # 2 == 2 , t5 = 0
lh $t5, 7
lhu $t5,7
lb $t5, 7
lbu $t5,7
lw $t5, 7
sh $t5,7
sb $t5,7
lui $t5, 2
sra $t5,$t5,1
srlv $t5,$t5,$t2
sll $t5, $t5, 1
addiu $t5, $zero, 8
addiu $t6, $zero, -3
mult $t5, $t6
multu $t5, $t6
mfhi $t5
mflo $t6
mthi $zero
mtlo $zero
addiu $t5, $zero, 8
addiu $t6, $zero, -3
div $t5, $t6
divu $t5,$t6



add $t0,$t1,$t1 #t0 = 2
slt $t4, $t0, $t1 #t4 = 0:t0>t1
beq $t4, $zero, bqj
j jmp
bqj:
add $t0,$t0,$t2 #t0=4
jmp:
slt $t1,$t2,$t2 #t1=0:t2==t2
bne $t0,$t1, jmp3
add $t0,$t0,$t2  #t0 = 4
jmp3:
jal jmp2
nop
jr $t7
add $t0,$t0,$t3
jmp2:
jalr $t7,$ra
nop
slt $t4, $zero, $t0 # t4=1: 0 < t0
add $t0,$t0,$t3 #t0 = 7
sw $t0,3

subu $t5, $zero, $t4 #-1
bgez $t5, lb1
bltz $t5, lb1
nop
lb1:
bgtz $t5, lb2
blez $t5, lb2
nop
lb2:
or $t5, $zero, $zero #0
bltz $t5, lb3
bgez $t5, lb3
nop
lb3:
bgtz $t5, lb4
blez $t5, lb4
nop
lb4:
addiu $t5,$zero,1
bltz $t5, lb5
bgez $t5, lb5
nop
lb5:
blez $t5, lb6
bgtz $t5, lb6
nop
lb6:

