maxIncome:
#finds the total income from the file
#arguments:	a0 contains the file record pointer array location (0x10040000 in our example) But your code MUST handle any address value
#		a1:the number of records in the file
#return value a0: heap memory pointer to actual  location of the record stock name in the file buffer

	#if empty file, return 0 for both a0, a1
	bnez a1, maxIncome_fileNotEmpty # maxIncome Function
	li a0, 0
	ret

 maxIncome_fileNotEmpty:
	#####################################################################################
	# Created by:	Yazmyn Sims
	#		yzsims
	#		11 March 2023
	#
	# Assignment:	Lab 4: Simple CSV File Analysis 
	#		CSE 12, Computer Systems and Assembly Language
	#		UC Santa Cruz, Winter 2023
	#
	# Description:	This program finds the max income in the provided csv file(s). 
	#
	# Notes:	This program is intended to be run from the MARS IDE. 
	###################################################################################
	
	# Start your coding from here!
	li t2, 0				#initalize values
	li t3, 0
	li t5, 5				#number of companies to loop through
	mv t1, a0
	addi t1, t1, 4				#Get first number				
									
	Max_Loop:				 
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
								
		bgt a0, t2, Max	#is a0 > t2
		
		addi t1, t1, 8		#Get Next number
		addi t3, t3, 1		#increment companies	
			
		beq t3, t5, End_Max
		
		
		j Max_Loop
		Max: 
			
			mv t2, a0
			addi t4, t1, -4
			addi t1, t1, 8		#Get Next number
			addi t3, t3, 1		#increment companies	
			beq t3, t5, End_Max			#Check for /r or (CR)
			j Max_Loop		#Continue until null	
	End_Max:	

	mv a0, t4
# End your  coding  here!
	
	ret
#######################end of maxIncome###############################################