

# R1 contains the first operand
		lw	R1,0( R0 )
# R2 contains the second operand
		lw	R2,4(R0)
# R3 contains the result
		xor 	R3,R3,R3
# R4 is used as counter
		xor	R4,R4,R4
main_loop:
		seq	R5,R4,R2
		bnez	R5,end_loop
		add	R3,R3,R1
		addi	R4,R4,1
		j	main_loop
end_loop:
# stores result in memory
		sw	R3,8(R0)



