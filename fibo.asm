.data

inMsg: .asciiz "Enter a number: "
msg: .asciiz "Calculating F(n) for n = "
fibNum: .asciiz "\nF(n) is: "
.text

main:

	li $v0, 4
	la $a0, inMsg
	syscall

	# take input from user
	li $v0, 5
	syscall
	addi $a0, $v0, 0
	
	jal print_and_run
	
	# exit
	li $v0, 10
	syscall

print_and_run:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	add $t0, $a0, $0 

	# print message
	li $v0, 4
	la $a0, msg
	syscall

	# take input and print to screen
	add $a0, $t0, $0
	li $v0, 1
	syscall

	jal fib

	addi $a1, $v0, 0
	li $v0, 4
	la $a0, fibNum
	syscall

	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################	
	
fib: 
	# $a0 = n, $v0 = return_value
	
	# Check if n == 0
	beq $a0, $0, return_zero 
	
	# Check if n == 1
	addi $t0, $0, 1 # $t1 = 1
	beq $a0, $t0, return_one
	
	
	addi $a0, $a0, -1 # $a0 = n-1
	addi $sp, $sp, -12 # Allocate space on the stack
	sw $ra, 8($sp) # Save the retrun address in the stack
	sw $v0, 4($sp) # Save return value in the stack
	sw $a0, 0($sp) # Save n in the stack
	
	
	jal fib # Compute fib(n-1)
	sw $v0, 4($sp) # Save return value in the stack
	
	lw $a0, 0($sp) # $a0 = n - 1
	addi $a0, $a0, -1 # $a0 = $a0 - 1
	sw $a0, 0($sp) # Save n-2 in the stack
	
	
	jal fib # Compute fib(n-2)
	
	lw $t0, 4($sp)
	add $v0, $v0, $t0 # $v0 = fib(n-1)
	
	lw $ra, 8($sp) # Load return address to the stack
	addi $sp, $sp, 12 # Restore stack pointer
	
	jr $ra
	
return_zero:
	add $v0, $0, $0 # $v0 = 0
	j end
	
return_one:
	addi $v0, $0, 1 # $v0 = 1
	j end
	
end:	
	# jump back to caller
	jr $ra
	
	
	
	
	
	
	
	
	
