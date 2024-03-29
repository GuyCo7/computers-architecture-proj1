# check if user provided string is palindrome

.data

userInput: .space 64
stringAsArray: .space 256

welcomeMsg: .asciiz "Enter a string: "
calcLengthMsg: .asciiz "Calculated length: "
newline: .asciiz "\n"
yes: .asciiz "The input is a palindrome!"
no: .asciiz "The input is not a palindrome!"
notEqualMsg: .asciiz "Outputs for loop and recursive versions are not equal"

.text

main:

	li $v0, 4
	la $a0, welcomeMsg
	syscall
	la $a0, userInput
	li $a1, 64
	li $v0, 8
	syscall

	li $v0, 4
	la $a0, userInput
	syscall
	
	# convert the string to array format
	la $a1, stringAsArray
	jal string_to_array
	
	addi $a0, $a1, 0
	
	# calculate string length
	jal get_length
	addi $a1, $v0, 0
	
	li $v0, 4
	la $a0, calcLengthMsg
	syscall
	
	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	la $a0, stringAsArray
	
	# Swap a0 and a1
	addi $t0, $a0, 0
	addi $a0, $a1, 0
	addi $a1, $t0, 0
	addi $t0, $zero, 0
	
	# Function call arguments are caller saved
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	# check if palindrome with loop
	jal is_pali_loop
	
	# Restore function call arguments
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	
	addi $s0, $v0, 0
	
	# check if palindrome with recursive calls
	jal is_pali_recursive
	bne $v0, $s0, not_equal
	
	beq $v0, 0, not_palindrome

	li $v0, 4
	la $a0, yes
	syscall
	j end_program

	not_palindrome:
		li $v0, 4
		la $a0, no
		syscall
		j end_program
	
	not_equal:
		li $v0, 4
		la $a0, notEqualMsg
		syscall
		
	end_program:
	li $v0, 10
	syscall
	
string_to_array:	
	add $t0, $a0, $zero
	add $t1, $a1, $zero
	addi $t2, $a0, 64

	
	to_arr_loop:
		lb $t4, ($t0)
		sw $t4, ($t1)
		
		addi $t0, $t0, 1
		addi $t1, $t1, 4
	
		bne $t0, $t2, to_arr_loop
		
	jr $ra


#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################
	
get_length:
	# $t0 = '\n', $a0 = base string (A)
	# $t1 = A[i], $v0 = length_counter

	lb $t0, newline # Load '\n' to $t0
	add $v0, $zero, $zero # $v0 = 0 (length_counter)
	
loop:
	lw $t1, 0($a0) # $t2 = A[i]
	beq $t1, $t0, exit # if (A[i] != '\n')
	addi $v0, $v0, 1 # $t1 += 1 (counter++)
	addi $a0, $a0, 4 # $a0 += 4 (move to the next location of the array)
	j loop
	
exit:
	jr $ra # Jump back to the caller
			
					
		
is_pali_loop:
	# $a0 = string_length, $a1 = base_string
	# $t0 = pointer to the end of the string
	
	addi $t1, $zero, 1 # $t1 = 1
	mul $t0, $a0, 4 # $t0 = string_length*4
	addi $t0, $t0 , -4 # $t0 -= 4
	add $t0, $t0, $a1 # $t0 = start + offset (now it points to the end of the string)
	
loop_recursive:
	ble $a0, $t1, is_pali # if (string_length <= 1)

	lw $t1, 0($a1) # $t1 = A[start]
	lw $t2, 0($t0) # $t2 = A[end]
	bne $t1, $t2, not_pali # if A[start] != A[end]
	
	addi $a1, $a1, 4 # start++
	addi $t0, $t0, -4 # end--
	addi $a0, $a0, -2 # string_length -= 2
	slt $t2, $a1, $t0 # $t2 = (start < end)
	beq $t2, $zero, is_pali # if (start >= end)
	j loop_recursive
	

not_pali:
	add $v0, $zero, $zero # $v0 = 0 (means - not pali)
	j end

is_pali:
	addi $v0, $zero, 1 # $v1 = 1 (means - pali)

end:
	jr $ra
	
	
	

is_pali_recursive:
	# $a0 = string_length, $a1 = base_string
	# $t0 = pointer to the end of the string
	
	# Save registers in the stack
	addi $sp, $sp, -12 # Allocate stack memory
	sw $ra, 8($sp) # Save return address in the stack
	sw $a0, 4($sp) # Save string_length in the stack
	sw $a1, 0($sp) # Save base_pointer in the stack
	
	addi $t4, $zero, 1 # $t4 = 1
	ble $a0, $t4, is_pali_rec # if (string_length <= 1)
	
	# Calculate the end pointer
	mul $t0, $a0, 4 # $t0 = string_length*4
	add $t0, $a1, $t0 # $t0 = start + offset
	addi $t0, $t0 , -4 # $t0 -= 4
	
	#slt $t3, $a1, $t0 # $t3 = (start < end)
	#beq $t3, $zero, is_pali_rec # if (start >= end)
	
	lw $t1, 0($a1) # $t1 = A[start]
	lw $t2, 0($t0) # $t2 = A[end]
	bne $t1, $t2, not_pali_rec # if A[start] != A[end]
	
	addi $a1, $a1, 4 # start++
	addi $t0, $t0, -4 # end--
	addi $a0 $a0, -2 # string_length -= 2
	
	jal is_pali_recursive
	
	# Restore registers from the stack
	lw $a1, 0($sp) # Restore base_pointer from the stack
	lw $a0, 4($sp) # Restore string_length from the stack
	lw $ra, 8($sp) # Restore return address from the stack
	addi $sp, $sp, 12 # Restore stack pointer
	
	jr $ra

not_pali_rec:
	add $v0, $zero, $zero # $v0 = 0 (means - not pali)
	j end_rec
	
is_pali_rec:
	addi $v0, $zero, 1 # $v0 = 1 (means - is pali)

end_rec:	
	jr $ra
