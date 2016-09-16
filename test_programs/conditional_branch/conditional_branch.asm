branch1:	
		addui	R1,R0,1
		beqz	R1,branch3

branch2:	
		xor	R1,R1,R1

branch3:	
		addui	R2,R0,2
		addui	R3,R0,3
		addui	R4,R0,4
		slt	R5,R2,R3
		sgt	R6,R2,R3
		bnez 	R6,branch2

branch4:	
		xor	R7,R7,R7
loop1:		
		addi	R7,R7,1
		seq	R6,R7,R4
		beqz	R6,loop1

		nop
		nop
		nop
		nop
		nop
