
					 #################################################
					 # 		 A programm that stores characters,		 #
					 # 		processes them and after removing		 #
					 # 		the special characters, prints the		 #
					 # 		rest.									 #
					 #################################################




.data 											# Data declaration section

array : .space 100								# Bind 100 bytes space in memory, array
arrayvol2 : .space 100							# Bind 100 bytes space in memory, arrayvol2
arrayvol3: .space 100							# Bind 100 bytes space in memory, arrayvol3
prompt: .asciiz "\nEnter a character: \n" 		# String to be printed, prompt
str: .asciiz "\n\nThe String is: \n" 			# String to be printrd, str
store: .byte ' '								# Bind 1 byte space in memory

.text 											# Assembly language instructions go in text segment

main: 											# Start of code section
 
	addi $t0, $zero, 0							# int i=0, (temporarily) stored at $t0
 
 
					 #################################################
					 # 		loop1: 									 #
					 # 		asks the user to enter characters 		 #
					 # 		and stores the inputs into an array 	 #
					 # 		until the input is @.					 #
					 #################################################


loop1:
	li $v0, 4 									# System call code for printing string = 4, store 4 at $v0
	la $a0, prompt								# Load address of string prompt to be printed into $a0
	syscall 	 								# Call operating system to perform operation
	
	li $v0, 12									# System call code for char input stored at $v0
	syscall										# Call operating system to perform operation
	
	beq $v0, 64, atchar							# If input == @ then jump to atchar label, break loop1
	sb $v0, array($t0)							# Else array[i]=input, which input is stored at $t0
	addi $t0, $t0, 1							# i++
	j  loop1									# Jump to loop1, continue loop1
	
	
					 #################################################
					 # 		atchar:									 #
					 # 		the programm goes to this label when	 #
					 # 		@ character is given and proceeds to 	 #
					 # 		add \n character at the end of the array.#					 
					 #################################################
	
	
	
atchar:											# Continue to atchar
	addi $t0, $t0, 1							# i++
	li $v0, 10									# v0=\n, note that ascii code for \n is 10
	sb $v0, array($t0)							# Store v0 to the last position of array array[i]=\n
	addi $t0, $zero, 0							# int i=0, (temporarily) stored at $t0, REUSE $t0


					 ##################################################
					 # 		loop2:									  #
					 # 		copies every single value of array to	  #
					 # 		arrayvol2, until all of them are copied.  #
					 #		$t1 represents the value of array with    #
					 #		index the value of $t0. When all chars    #
					 #		are copied, then array with index $t0     #
					 # 		won't point anywhere, therefore $t1=$zero #
					 ##################################################
					 
					 
	
loop2:											# Continue to loop2
	addi $t2, $zero, 0							# int u=0, (temporarily) stored at $t2
	addi $t4, $zero, 0							# int o=0, (temporarily) stored at $t4
	lbu $t1, array($t0)							# Load array(i) into $t1
	beq $t1, $zero, loop3						# If $t1=array(i) == 0 then jump to loop3, break loop2
	sb $t1, arrayvol2($t0)						# Else store arrayvol2(i) to $t1, $t1 = arrayvol2(i)
	addi $t0, $t0, 1							# i++
	j loop2										# Jump to loop2, continue loop2
	
	
	
					 #################################################
					 # 		loop3:									 #
					 # 		a loop that "gets rid" of not useful	 #
					 # 		characters (special chars).				 #
					 #		This procedure is done by 				 #
					 #		categorizing chars in 'do' and 'skip'.	 #
					 #		Those in 'do' will be added in arrayvol3,#
					 # 		when those in skip won't.				 #
					 #		Categorisation happens by looking at the #
					 #		Ascii table.							 #
					 #################################################	
	
	
	
loop3:											# Continue to loop3
	lbu $t1, arrayvol2($t2)						# Load arrayvol2(u) into $t1, $t1 = arrayvol2(u)
	beq $t1, $zero, end							# If arrayvol2(u) == 0 then jump to end
	beq $t1, 32, do								# Else if arrayvol2(u) == " " then jump to do
	blt $t1, 48, skip							# Else if arrayvol2(u) is a special char then jump to skip
	bgt $t1, 122, skip							# Else if arrayvol2(u) is a special char then jump to skip
	blt $t1, 58, do								# Else if arrayvol2(u) is a not special char then jump to do
	bgt $t1, 96, do								# Else if arrayvol2(u) is a not special char then jump to do
	blt $t1, 65, skip							# Else if arrayvol2(u) is a special char then jump to skip
	bgt $t1, 90, skip							# Else if arrayvol2(u) is a special char then jump to skip
	do:											# Continue to do
		sb $t1, arrayvol3($t4)					# Store $t1 = arrayvol2(o) into arrayvol3(o)
		addi $t4, $t4, 1						# o++
												# $t4 represents the index of the arrayvol3 so we
												# add 1 to it only when a char is added to it.
	skip: 										# Continue to skip
		addi $t2, $t2, 1						# u++
												# u represents the index arrayvol2
		j loop3									# Jump to loop3
		
		
					 #################################################
					 # 		end:									 #
					 # 		the programm prints the array with chars #
					 # 		and terminates.							 #				 
					 #################################################
	
	

end:											# Continue to end
	li $v0, 4									# System call code for printing string = 4, load 4 into $v0
	la $a0, str									# Load address of string to be printed into $a0
	syscall										# Call operating system to perform operation
	la $a0, arrayvol3							# Load address of arrayvol3 to be printed into $a0
	syscall										# Call operating system to perform operation
	li $v0, 10									# System call code for printing new line = 4, load 10 into $v0			
	syscall										# Call operating system to perform operation
