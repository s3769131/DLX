# A simple bubble sort implementation

# Load in R1 the address of the array
# Load in R2 the dimension of the array
start:
        addui   R1,R0,0x10      # 24010010
        addui   R2,R0,5         # 24020005
        xor     R9,R9,R9        # 01294826
outer_loop:
        add     R31,R0,R1       # 0001F820
        xor     R3,R3,R3        # 00631826
inner_loop:
        lw      R4,0(R31)       # 8FE40000
        lw      R5,4(R31)       # 8FE50004
        slt     R6,R4,R5        # 0085302A
        bnez    R6,continue     # 14C0000C
swap:
        add     R7,R0,R4        # 00043820
        add     R4,R0,R5        # 00052020
        add     R5,R0,R7        # 00072820
continue:
        addi    R31,R31,4       # 23FF0004
        addi    R3,R3,1         # 20630001
        sw      R4,0(R31)       # AFF40000
        sw      R5,4(R31)       # AFF50004
        slt     R8,R3,R2        # 0062402A
        bnez    R8,inner_loop   # 1500FFCC
        addi    R9,R9,1         # 21290001
        slt     R10,R9,R2       # 0122502A
        bnez    R10,outer_loop  # 1540FFB8
end:
        nop                     # 54000000
        nop                     # 54000000
        nop                     # 54000000
        nop                     # 54000000
        nop                     # 54000000
