# income_from_record:
#function to return numerical income from a specific record
#e.g. for record "Microsoft,34\r\n", income to return is 34(for which name is Microsoft)

#arguments:
#  a0 contains pointer to start of array for numerical income records 

#function RETURNS income numerical value of the asci income in a0 (34 in our example)
	
# Start your coding from here!


.macro	nextChar
        # function causes a1 points to char value at nextCharPtr
        # a0 points to nextCharPtr before and after.
	lbu a1, 0(t5)   	# a1 = *nextChar MACRO
	addi t5, t5, 1		# nextChar++; point to new nextChar
.end_macro

income_from_record:
        lwu a0,0(a0)	# go indirecte from the pointer of the income record to the record itself.
	# Note, this is a leaf function, so it does not need to spill any registers.
	.eqv CR 13
	.eqv TEN 10
	# Assumes a0 has a pointer to buffer location having ascii version of number
	# nextChar will acquire the next digit.
	# Assume the ASCII digits for the amount ends in CR/LF
	# the function will return its value in a0
	# this function uses t3,t4,t6 as an interim, no worries, since it is a leaf function.
	nop		  # start income_from_record function #############################
	li t3, CR
	li t4 TEN
	li t6,0 
	mv t5, a0         # change running address be other than a0.
	nextChar          # returns initial ascii char, a digit or CR in reg a1, t5 points to next char
# START YOUR CODE HERE: USE PRINTING MACROS AND RARS DEBUGGER TO TROUBLESHOOT YOUR PROGRAM.	
	li t1, 0			#set t1 = 0
	IncomeRecloop:				
		#lbu t2, 0(t5)		#Get character 
		mv t2, a1
		
		beq t2, t3, EndRec	#Check for /r or (CR)
		addi t2, t2, -48	#Convert from ASCII to Integer	(character - ASCII 0)	
		
		add t1, t1, t2		#Add number to previous number
		mul t1,t1, t4		#Multiply by 10 	
		nextChar		#Next character
		j IncomeRecloop		#Continue until null
	EndRec:
		div t1,t1, t4		#divide result by 10
		addi a0, t1, 0		#add numbers back in a0
		
###### END YOUR CODE HERE, MAKE SURE YOU RETURN THE CORRECT BINARY NUMBER IN REGISTER a0 ####
	ret   ### end of income_from_record function ########################################
