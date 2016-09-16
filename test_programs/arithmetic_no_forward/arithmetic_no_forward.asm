
# Initialize some of the registers

addui	R1,R0,21
addui	R2,R0,22
addui	R3,R0,23
addui	R4,R0,24
addui	R5,R0,25
addui	R6,R0,26
addui	R7,R0,27
addui	R8,R0,28
addui	R9,R0,1
addui	R10,R0,-2
addui	R11,R0,3
addui	R12,R0,4
addui	R13,R0,5
addui	R14,R0,6
addui	R15,R0,7

# Test add
addui	R16,R1,10
addi	R17,R2,-1

# Test sub
subui	R18,R3,23
subi	R19,R4,-24

# Test bitwise
andi	R20,R5,8
ori	R21,R6,15
xori	R22,R7,26

# Test shift
slli	R23,R8,1
srli	R24,R9,4
srai	R25,R10,8

# Test logic condition
seqi	R26,R11,-3
snei	R27,R12,3
slti	R28,R13,-3
sgti	R29,R14,3
slei	R30,R15,-7
sgei	R31,R15,9

sequi	R26,R11,3
sneui	R27,R12,3
sltui	R28,R13,3
sgtui	R29,R14,3
sleui	R30,R15,7
sgeui	R31,R15,9

