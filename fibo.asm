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
	beq $a0, $0, ret_zero 
	
	# Check if n == 1
	addi $t0, $0, 1 # $t1 = 1
	beq $a0, $t0, ret_one
	
	# else (n is not 0 or 1)
	addi $sp, $sp, -12 # Allocate space on the stack
	sw $ra, 0($sp) # save the retrun address in the stack
	sw $a0, 4($sp) # save n in the stack
	sw $v0, 8($sp) # save return value in the stack
	
	# Compute fib(n-1)
	addi $a0, $a0, -1 # $a0 = n-1
	jal fib # call fib function with n-1
	add $t1, $v0, $0 # $t1 = fib(n-1)
	
	# Restore stack
	lw $v0, 8($sp) # Restore return value from the stack
	lw $a0, 4($sp) # Restore n from the stack
	lw $ra, 0($sp) # Restore return address from the stack
	addi $sp, $sp, 12 # Restore stack pointer
	
	# Compute fib(n-2)
	addi $a0, $a0, -2 # $a0 = n-2
	jal fib # call fib with n-2
	add $t2, $v0, $0 # $t2 = fib(n-2)
	
	
	add $v0, $t1, $t2 # $v0 = fib(n-1) + fib(n-2)
	
	j end
	
ret_zero:
	add $v0, $0, $0 # $v0 = 0
	j end
	
ret_one:
	addi $v0, $0, 1 # $v0 = 1
	j end
	
end:	
	# jump back to caller
	jr $ra
	
	
	
	
	
	
	
	
	
