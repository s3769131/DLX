
# Initialize all registers

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

sll     R1,R1,R1
srl     R2,R2,R2
sra     R3,R3,R3

add     R4,R4,R4
addu    R5,R5,R5

sub     R6,R6,R6
subu    R7,R7,R7

and     R8,R8,R8
or      R9,R9,R9
xor     R10,R10,R10

seq     R11,R11,R11
sne     R12,R12,R11
slt     R13,R12,R13
sgt     R14,R14,R14
sle     R15,R14,R14
sge     R16,R15,R16

sltu    R13,R12,R13
sgtu    R14,R14,R14
sleu    R15,R14,R14
sgeu    R16,R15,R16

# Initialize all registers

addi    R1,R0,1
addi    R2,R0,2
addi    R3,R0,3
addi    R4,R0,4
addi    R5,R0,5
addi    R6,R0,6
addi    R7,R0,7
addi    R8,R0,8
addi    R9,R0,9
addi    R10,R0,-10
addi    R11,R0,11
addi    R12,R0,-12
addi    R13,R0,13
addi    R14,R0,-14
addi    R15,R0,15
addi    R16,R0,-16

# Test REG-IMM instructions

slli    R1,R1,3
srli    R2,R2,3
srai    R3,R3,3

addi    R4,R4,-3
addui   R5,R5,-2

subi    R6,R6,6
subui   R6,R6,1

andi    R7,R7,0
ori     R8,R8,-1
xori    R9,R9,0

seqi    R10,R10,-1
snei    R11,R11,2
slti    R12,R12,-13
sgti    R13,R13,14
slei    R14,R14,-14
sgei    R15,R15,15

sltui   R12,R12,0
sgtui   R13,R13,0
sleui   R14,R14,0
sgeui   R15,R15,0
