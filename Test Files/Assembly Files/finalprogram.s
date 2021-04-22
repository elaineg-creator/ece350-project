nop
nop
addi $31, $31, 60
b1: second 0
addi $1, $1, 1
servo $1
bne $1, $31, b1

b2: addi $31, $31, -1
sound 0
addi $2, $2, 1
add $1, $0, $0
servo $2

b3: second 0
addi $1, $1, 1
servo $1
bne $1, $31, b3

sound 0
addi $2, $2, 1
add $1, $0, $0
servo $2
bne $2, $31, b3

