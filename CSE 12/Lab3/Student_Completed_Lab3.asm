.macro exit #macro to exit program
	li a7, 10
	ecall
	.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
	
.macro read_n(%x)#macro to input integer n into register x
	li a7, 5
	ecall 		
	#a0 now contains user input
	addi %x, a0, 0
	.end_macro
	

.macro 	file_open_for_write_append(%str)
	la a0, %str
	li a1, 1
	li a7, 1024
	ecall
.end_macro
	
.macro  initialise_buffer_counter
	#buffer begins at location 0x10040000
	#location 0x10040000 to keep track of which address we store each character byte to 
	#actual buffer to store the characters begins at 0x10040008
	
	#initialize mem[0x10040000] to 0x10040008
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t1, 8(sp)
	
	li t0, 0x10040000
	li t1, 0x10040008
	sd t1, 0(t0)
	
	ld t0, 0(sp)
	ld t1, 8(sp)
	addi sp, sp, 16
	.end_macro
	

.macro write_to_buffer(%char)
	
	
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t4, 8(sp)
	
	
	li t0, 0x10040000
	ld t4, 0(t0)#t4 is starting address
	#t4 now points to location where we store the current %char byte
	
	#store character to file buffer
	li t0, %char
	sb t0, 0(t4)
	
	#update address location for next character to be stored in file buffer
	li t0, 0x10040000
	addi t4, t4, 1
	sd t4, 0(t0)
	
	ld t0, 0(sp)
	ld t4, 8(sp)
	addi sp, sp, 16
	.end_macro

.macro fileRead(%file_descriptor_register, %file_buffer_address)
#macro reads upto first 10,000 characters from file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a2, 10000
	li a7, 63
	ecall
.end_macro 

.macro fileWrite(%file_descriptor_register, %file_buffer_address,%file_buffer_address_pointer)
#macro writes contents of file buffer to file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a7, 64
	
	#a2 needs to contains number of bytes sent to file
	li a2, %file_buffer_address_pointer
	ld a2, 0(a2)
	sub a2, a2, a1
	
	ecall
.end_macro 

.macro print_file_contents(%ptr_register)
	li a7, 4
	addi a0, %ptr_register, 0
	ecall
	#entire file content is essentially stored as a string
.end_macro
	


.macro close_file(%file_descriptor_register)
	li a7, 57
	addi a0, %file_descriptor_register, 0
	ecall
.end_macro

.data	
	prompt: .asciz  "Enter the height of the pattern (must be greater than 0):"
	invalidMsg: .asciz  "Invalid Entry!"
	newline: .asciz  "\n" #this prints a newline
	star: .asciz "*"
	blankspace: .asciz " "
	outputMsg: .asciz  " display pattern saved to lab3_output.txt "
	filename: .asciz "lab3_output.txt"

.text

	file_open_for_write_append(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	
	initialise_buffer_counter
	
	#for utilsing macro write_to_buffer, here are tips:
	#0x2a is the ASCI code input for star(*)
	#0x20  is the ASCI code input for  blankspace
	#0x0a  is the ASCI code input for  newline (/n)

	
	#START WRITING YOUR CODE FROM THIS LINE ONWARDS
	#DO NOT  use the registers a0, a1, a7, t6, sp anywhere in your code.
	
	#................ your code here..........................................................#
	
	#####################################################################################
	# Created by:	Yazmyn Sims
	#		yzsims
	#		6 March 2023
	#
	# Assignment:	Lab 3: Looping in RISC-V Assembly 
	#		CSE 12, Computer Systems and Assembly Language
	#		UC Santa Cruz, Winter 2023
	#
	# Description:	This program prints a triangle based on the dimensions 
	#		provided by the user.
	#
	# Notes:	This program is intended to be run from the MARS IDE. 
	###################################################################################
	
	#Register Usage:
		#t0: User input
		#t1: loop counter
		#t2: loop counter
		
	#--------------Input-----------------#
	li t1, 1				#initialize value t1
promptbody:					#Displays prompt
	print_str(prompt)
	print_str(newline)
	read_n(t0)				#Reads User Input

	bgtz t0, OutterLoop			#If Input >0 go to the outter loop... 
	print_str(invalidMsg)			#...else print the invalid Message...
	print_str(newline)
	b promptbody				#...and return to display prompt again

		
	#--------------Outter Loop-----------------#	
OutterLoop:
	li t2, 2				#initialize value t2
	
	#--------------Print First Star-----------------#	
	printFirstStar:				#print the top *
		print_str(star)
		write_to_buffer(0x2a)		#write * in buffer
	
	#-------------- Inner Loop-----------------#	
	InnerLoop:
		beq t2, t1, printStar		#if t2 = t1, print star...
		beq t1, t0, printStar		#...or if t1 = t0 print star...
		b printBlank			#...else print blank space
		
	#--------------Print Star-----------------#	
		printStar:
			print_str(star)
			write_to_buffer(0x2a)	#write * to buffer
		b increment			#after printing a star, increment t2 and t1 values
		
	#--------------Print Blank----------------#	
		printBlank:
			print_str(blankspace)
			write_to_buffer(0x20)	#Write blank space to buffer	
	#--------------Increment-----------------#	
		increment:
			addi t2, t2, 1
			ble t2, t1, InnerLoop	#after incrementing t2 and t1 values return to the start of the inner loop
				
	print_str(newline)			#print new line
	write_to_buffer(0x0a)			#write newline to buffer
	
	addi t1, t1, 1				#increment t1
	
	ble t1, t0, OutterLoop 			#if t1 >= t0, go back to the start of the outter loop
	
	#END YOUR CODE ABOVE THIS COMMENT
	
	#write null character to end of file
	write_to_buffer(0x00)
	
	#write file buffer to file
	fileWrite(t6, 0x10040008,0x10040000)
	addi t5, a0, 0
	
	print_str(newline)
	print_str(outputMsg)
	
	exit
