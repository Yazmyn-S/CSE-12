totalIncome:
#finds the total income from the file
#arguments:	a0 contains the file record pointer array location (0x10040000 in our example) But your code MUST handle any address value
#		a1:the number of records in the file
#return value a0:the total income (add up all the record incomes)

	#if empty file, return 0 for  a0
	bnez a1, totalIncome_fileNotEmpty # totalIncome function
	li a0, 0
	ret

totalIncome_fileNotEmpty:			
	# Start your coding from here!
	li t2, 0				#initalize values
	li t3, 0
	li t5, 5
	mv t1, a0
	addi t1, t1, 4				#Get first number				
									
	Total_Loop:				 
		push(t1)
		push(t2)
		push(t3)
		push(t5)
		push(ra)
		
		mv a0, t1
		jal income_from_record	

		pop(ra)
		pop(t5)
		pop(t3)
		pop(t2)
		pop(t1)
				
		add t2, a0, t2				#add numbers
		addi t1, t1, 8				#Get Next number
		addi t3, t3, 1				#increment 
		beq t3, t5, End_Total			#Check for /r or (CR)			
		j Total_Loop				#Continue until null	
	End_Total:	

	mv a0, t2
	#if no student code entered, a0 just returns 0 always :(
# End your coding  here!
	
	ret
#######################end of nameOfMaxIncome_totalIncome###############################################
