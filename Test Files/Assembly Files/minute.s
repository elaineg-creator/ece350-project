nop
nop
addi $31, $31, 59
b1: second 0
addi $1, $1, 1
servo $1
bne $1, $31, b1


addi $2, $2, 1
add $1, $0, $0
servo $2

