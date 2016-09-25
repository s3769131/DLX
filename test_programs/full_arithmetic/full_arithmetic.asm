# initialize all registers

addui   R1,R0,1
addui   R2,R0,2
addui   R3,R0,3
addui   R4,R0,4
addui   R5,R0,5
addui   R6,R0,6
addui   R7,R0,7
addui   R8,R0,8
addui   R9,R0,9
addui   R10,R0,10
addui   R11,R0,11
addui   R12,R0,12
addui   R13,R0,13
addui   R14,R0,14
addui   R15,R0,15
addui   R16,R0,16

# Test each arithmetic REG-REG instruction

sll     R31,R1,R1
srl     R31,R2,R2
sra     R31,R3,R1

add     R31,R4,R4
addu    R31,R5,R5

sub     R31,R6,R6
subu    R31,R7,R7

and     R31,R8,R8
or      R31,R9,R9
xor     R31,R10,R10

seq     R31,R11,R11
sne     R31,R12,R11
slt     R31,R12,R13
sgt     R31,R14,R14
sle     R31,R14,R14
sge     R31,R15,R16

sltu    R31,R12,R13
sgtu    R31,R14,R14
sleu    R31,R14,R14
sgeu    R31,R15,R16

# Test REG-IMM instructions

slli    R31,R1,3
srli    R31,R2,3
srai    R31,R3,3

addi    R31,R4,-3

subi    R31,R6,6

andi    R31,R7,0
ori     R31,R8,-1
xori    R31,R9,0

seqi    R31,R10,-1
snei    R31,R11,2
slti    R31,R12,-13
sgti    R31,R13,14
slei    R31,R14,-14
sgei    R31,R15,15
