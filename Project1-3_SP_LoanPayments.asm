# File: Project1-3_SP.asm										
# Assignment: Project 1 Part 3										
# Name: Steven Perry, #800383399								
# Course: CS286-001										
# Created: 9/19/2017								
# Description: Program in MIPS assembly. Calculate and display loan payment
#	       information using floating point numbers.


.data
	STR_REQPRIN: .asciiz "\nEnter the principal in $ (100.00 - 1,000,000.00): "
	STR_REQYINTRATE: .asciiz "\nEnter the annual interest rate (0.005 - 0.399): "
	STR_REQMOPAY: .asciiz "\nEnter the monthly payment amount in $ (1.00 - 1,000,000.00): "
	STR_INVALINPUT: .asciiz "\n\nYour input was invalid. Please try again."
	STR_LOOP_ERR: .asciiz "\n\nYour monthly payment is too low. You will never pay the loan off."
	STR_MONTH: .asciiz "\nmonth "
	STR_CURRPRIN: .asciiz ": current principal = "
	STR_ITWILL: .asciiz "\n\nIt will take "
	STR_MONTHSTO: .asciiz " months to complete the loan."
	
.text
	.globl main

main:
	REQPRIN:	li $v0, 4			# system call for print string
			la $a0, STR_REQPRIN		# specify principal prompt
			syscall				# displays principal prompt

			li $v0, 6			# system call for read_float
			syscall				# get float from user
			mov.s $f1, $f0			# move user float into f1
			
			li.s $f2, 100.00		# load 100.00 into f2
			c.lt.s $f1, $f2			# if f1<f2, set c flag
			bc1t INVALPRIN			# if c flag true, jump to INVALPRIN

			li.s $f2, 1000000.00		# load 1000000.00 into f2
			c.lt.s $f2, $f1			# if f2<f1, set c flag
			bc1t INVALPRIN			# if c flag true, jump to INVALPRIN

			mov.s $f13, $f1			# store valid PRIN in f13
			j REQYINTRATE			# jump to REQYINTRATE

	INVALPRIN:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify invalid input message
			syscall				# displays invalid input message

			j REQPRIN			# jump to principal prompt again

	REQYINTRATE:	li $v0, 4			# system call for print string
			la $a0, STR_REQYINTRATE		# specify yearly interest rate prompt
			syscall				# displays yearly interest rate prompt

			li $v0, 6			# system call for read_float
			syscall				# get float from user
			mov.s $f1, $f0			# move user float into f1
			
			li.s $f2, 0.005			# load 0.005 into f2
			c.lt.s $f1, $f2			# if f1<f2, set c flag
			bc1t INVALRATE			# if c flag true, jump to INVALRATE

			li.s $f2, 0.399			# load 0.399 into f2
			c.lt.s $f2, $f1			# if f2<f1, set c flag
			bc1t INVALRATE			# if c flag true, jump to INVALRATE

			mov.s $f14, $f1			# store valid YINTRATE in f14
			j REQMOPAY			# jump to REQMOPAY

	INVALRATE:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify invalid input message
			syscall				# displays invalid input message

			j REQYINTRATE			# jump to yearly interest rate prompt again

	REQMOPAY:	li $v0, 4			# system call for print string
			la $a0, STR_REQMOPAY		# specify monthly payment prompt
			syscall				# displays monthly payment prompt

			li $v0, 6			# system call for read_float
			syscall				# get float from user
			mov.s $f1, $f0			# move user float into f1
			
			li.s $f2, 1.00			# load 1.00 into f2
			c.lt.s $f1, $f2			# if f1<f2, set c flag
			bc1t INVALPAY			# if c flag true, jump to INVALPAY

			li.s $f2, 1000000.00		# load 1000000.00 into f2
			c.lt.s $f2, $f1			# if f2<f1, set c flag
			bc1t INVALPAY			# if c flag true, jump to INVALPAY

			mov.s $f15, $f1			# store valid MOPAY in f15
			j LOOPCHECK			# jump to LOOPCHECK

	INVALPAY:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify invalid input message
			syscall				# displays invalid input message

			j REQMOPAY			# jump to monthly payment prompt again

	LOOPCHECK:	li.s $f1, 30.0			# load 30 into f1
			li.s $f2, 365.0			# load 36 into f2
			div.s $f1, $f1, $f2		# f1 (MOFRAC) = 30/365
			mul.s $f16, $f14, $f1		# f16 (MOINTRATE) = YINTRATE * MOFRAC
			mul.s $f3, $f13, $f16		# f3 (MOINT) = PRIN * MOINTRATE

			c.lt.s $f3, $f15		# if MOINT<MOPAY set c flag
			bc1f LOOP_ERR			# if c flag false, jump to LOOP_ERR
			
			j LOOPSETUP			# else jump to LOOPSETUP

	LOOP_ERR:	li $v0, 4			# system call for print string
			la $a0, STR_LOOP_ERR		# specify loop error message
			syscall				# displays loop error message

			jr $31				# return to main

	LOOPSETUP:	li $s0, 0			# s0 = 0, this will be our loop counter/MONTHS	

			j LOOPOUTPUT			# since it's the first month, we skip payment/interest	

	LOOPRUN:	mul.s $f1, $f13, $f16		# f1 (MOINT) = PRIN * MOINTRATE
			sub.s $f2, $f15, $f1		# f2 (PRINPAY) = MOPAY - MOINT
			sub.s $f13, $f13, $f2		# f13 (CURRPRIN) = PRIN - PRINPAY
						
	LOOPOUTPUT:	addi $s0, $s0, 1		# add 1 to loop counters/MONTHS

			li $v0, 4			# system call for print string
			la $a0, STR_MONTH		# specify month string
			syscall				# displays month string

			li $v0, 1			# system call for print integer
			move $a0, $s0			# specify loop counter/MONTHS integer
			syscall				# displays month integer

			li $v0, 4			# system call for print string
			la $a0, STR_CURRPRIN		# specify current principal string
			syscall				# displays current principal string

			li $v0, 2			# system call for print float
			mov.s $f12, $f13		# specify CURRPRIN float
			syscall				# displays CURRPRIN float

			c.lt.s $f13, $f15		# if CURRPRIN<MOPAY, set c flag
			bc1t LOOPEND			# if c flag true, jump to LOOPEND

			j LOOPRUN			# repeat loop otherwise

	LOOPEND:	li $v0, 4			# system call for print string
			la $a0, STR_ITWILL		# specify it will string
			syscall				# displays it will string

			li $v0, 1			# system call for print integer
			move $a0, $s0			# specify loop counter/MONTHS integer
			syscall				# displays month integer

			li $v0, 4			# system call for print string
			la $a0, STR_MONTHSTO		# specify months to string
			syscall				# displays months to string
		
			jr $31				# return to main
