minIncome:
#finds the total income from the file
#arguments:	a0 contains the file record pointer array location (0x10040000 in our example) But your code MUST handle any address value
#		a1:the number of records in the file
#return value a0:the total income (add up all the record incomes)

	#if empty file, return 0 for both a0, a1
	bnez a1, minIncome_fileNotEmpty # minIncome function
	li a0, 0
	ret

 minIncome_fileNotEmpty:
	li t2, 111				#initalize values
	li t3, 0
	li t5, 5				#number of companies to loop through
	mv t1, a0
	addi t1, t1, 4				#Get first number				
									
	Min_Loop:				 
		push(t1)
		push(t2)
		push(t3)
		push(t4)
		push(t5)
		push(ra)
		
		mv a0, t1
		jal income_from_record	

		pop(ra)
		pop(t5)
		pop(t4)
		pop(t3)
		pop(t2)
		pop(t1)
								
		blt a0, t2, Min	#is a0 < t2
		
		addi t1, t1, 8		#Get Next number
		addi t3, t3, 1		#increment companies	
			
		beq t3, t5, End_Min
		
		j Min_Loop
		Min: 
			mv t2, a0
			addi t4, t1, -4
			addi t1, t1, 8		#Get Next number
			addi t3, t3, 1		#increment companies	
			beq t3, t5, End_Min	#Check for /r or (CR)
			j Min_Loop		#Continue until null	
	End_Min:	

	mv a0, t4

	ret
#######################end of minIncome###############################################
