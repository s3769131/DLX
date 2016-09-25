# R1 contains the first operand
        lw      R1,4(R0)            # 8C010004
# R2 contains the second operand
        lw      R2,8(R0)            # 8C020008
# R3 contains the result
        xor     R3,R3,R3            # 00631826
# R4 is used as counter
        xor     R4,R4,R4            # 00842026
main_loop:
        seq     R5,R4,R2            # 00822828
        bnez    R5,end_loop         # 14A0000C
        add     R3,R3,R1            # 00611820
        addi    R4,R4,1             # 20840001
        j       main_loop           # 0BFFFFEC
end_loop:
# stores result in memory
        sw      R3,C(R0)            # AC03000C
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
