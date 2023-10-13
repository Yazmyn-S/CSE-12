length_of_file:
#function to find length of data read from file
#arguments: a1=bufferAdress holding file data
#return file length in a0
	
#Start your coding here
	li a0, 0 			# initialize counter

	Null_loop:
		lbu t2, 0(a1) 		#load char
		beqz t2, End_loop 	#check for null
		addi a0, a0, 1 		#increment
		addi a1, a1, 1 		#next character
		j Null_loop

	End_loop:
				
#if no student code provided, this function just returns 0 in a0
#End your coding here
	
	ret
#######################end of length_of_file###############################################	