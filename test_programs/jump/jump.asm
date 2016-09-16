start:
		addui	R1,R0,1
		j	j1
		nop
		j	j5
j1:
		jal	j2
		nop
		nop
j2:
		addui	R4,R0,4
		jr	R4
		nop
		nop
j5:
		jalr	R4

