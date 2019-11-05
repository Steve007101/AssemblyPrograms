# File: Project2_SP.asm										
# Assignment: Project 2										
# Name: Steven Perry, #800383399								
# Course: CS286-001										
# Created: 10/26/2017								
# Description: Program in MIPS assembly. Asks user to enter two numbers between 1 and 9999.
#	       Calculate the GCD while dsplaying how many recursive rounds were needed.
#              Note: I went off of the example for when to add to the round counter


.data
	STR_REQNUM1: .asciiz "\nEnter the first number (1-9999): "
	STR_INVALNUM: .asciiz "\nYour input was invalid, please try again (1-9999): "
	STR_REQNUM2: .asciiz "\nEnter the second number (1-9999): "
	STR_ROUND: .asciiz "\nRecursive Round: "
	STR_GCD: .asciiz "\n\nGCD: "

.text
	.globl main

main:	

			subu $sp, $sp, 20		# create program stack frame
			sw $ra, 0($sp)			# save $ra 
			sw $s0, 4($sp)			# save s0
			sw $s1, 8($sp)			# save s1
			sw $s2, 12($sp)			# save s2
			sw $s3, 16($sp)			# save s3

	REQNUM1:	li $v0, 4			# system call for print string
			la $a0, STR_REQNUM1		# specify first prompt
			syscall				# displays first prompt

			li $v0, 5			# system call for read_int
			syscall				# get int from user
			move $t0, $v0			# move user int into t0
			
			li $t1, 9999			# load 200 into t1
			bgt $t0, $t1, INVALNUM1		# if t0 > 9999, jump to INVALNUM1

			li $t1, 1			# load 1 into t1
			blt $t0, $t1, INVALNUM1		# if t0 < 1, jump to INVALNUM1

			move $s0, $t0			# move validated input from t0 to s0
			j REQNUM2			# jump to REQNUM2

	INVALNUM1:	li $v0, 4			# system call for print string
			la $a0, STR_INVALNUM		# specify first error message
			syscall				# displays first error message

			j REQNUM1			# jumps to first prompt again

	REQNUM2:	li $v0, 4			# system call for print string
			la $a0, STR_REQNUM2		# specify second prompt
			syscall				# displays second prompt

			li $v0, 5			# system call for read_int
			syscall				# get int from user
			move $t0, $v0			# move user int into t0
			
			li $t1, 9999			# load 200 into t1
			bgt $t0, $t1, INVALNUM2 	# if t0 > 9999, jump to INVALNUM2

			li $t1, 1			# load 1 into t1
			blt $t0, $t1, INVALNUM2		# if t0 < 1, jump to INVALNUM2

			move $s1, $t0			# move validated input from t0 to s1
			j GCDSTART			# jump to GCDSTART

	INVALNUM2:	li $v0, 4			# system call for print string
			la $a0, STR_INVALNUM		# specify first error message
			syscall				# displays first error message

			j REQNUM2			# jumps to second prompt again

	GCDSTART:	li $s2, 0			# s2 = 0, this will be our GCD round counter
			jal GCD				# start the GCD subroutine
			j GCDOUTPUT			# jump to GCDOUTPUT when done

	GCD:		subu $sp, $sp, 12		# create stack frame
			sw $ra, 0($sp)			# save $ra register
			sw $s0, 4($sp)			# save s0/num1
			sw $s1, 8($sp)			# save s1/num2

			addi $s2, $s2, 1		# add 1 to round counter

			li $v0, 4			# system call for print string
			la $a0, STR_ROUND		# specify round string
			syscall				# displays round string

			li $v0, 1			# system call for print int
			move $a0, $s2			# specify round counter
			syscall				# displays round counter

			move $s3, $s0			# store current num1 in s3 (might be GCD)
			beq $s1, $zero, GCDEND		# end this round if num2 = 0

			div $s0, $s1			# divide num1/num2
			mfhi $t0			# store modulus of num1/num2 in t0

			move $s0, $s1			# store num2 in num1
			move $s1, $t0			# store original num1 mod num2 in num 2

			jal GCD				# recursively call GCD

	GCDEND:		lw $s0, 4($sp)			# load register s0
			lw $s1, 8($sp)			# load register s1
			lw $ra, 0($sp)			# restore $ra register for caller
			addu $sp, $sp, 12		# restore the caller's stack pointer

			jr $ra				# return to caller
			
	GCDOUTPUT:	li $v0, 4			# system call for print string
			la $a0, STR_GCD			# specify GCD string
			syscall				# displays GCD string

			li $v0, 1			# system call for print int
			move $a0, $s3			# specify GCD
			syscall				# displays GCD

			lw $ra, 0($sp)			# load $ra 
			lw $s0, 4($sp)			# load s0
			lw $s1, 8($sp)			# load s1
			lw $s2, 12($sp)			# load s2
			lw $s3, 16($sp)			# load s3
			addu $sp, $sp, 20		# restore the caller's stack pointer

			jr $31				# return to main

# s0 = num 1/working GCD x value
# s1 = num 2/working GCD y value
# s2 = GCD round counter
# s3 = GCD final value
# t0 = temporary storage for modulus operation
