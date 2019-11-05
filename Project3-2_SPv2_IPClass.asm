# File: Project3-2_SPv2.asm										
# Assignment: Project 3, Program 2										
# Name: Steven Perry, #800383399								
# Course: CS286-001										
# Created: 12/4/2017								
# Description: Program in MIPS assembly. Asks user to enter an IP address.
#	       Determines what class of domain it is then checks if a
#	       matching domain was found in an IP routing table.
# NOTE TO INSTRUCTOR: This version outputs the line # from the table instead.


.data
	STR_IPPROMPT: .asciiz "\nEnter an IP address: "
	STR_INVALINPUT: .asciiz "Invalid input, please try again (1-255)."
	STR_FIRST: .asciiz "\nFirst: "
	STR_SECOND: .asciiz "Second: "
	STR_THIRD: .asciiz "Third: "
	STR_FOURTH: .asciiz "Fourth: "
	STR_IP: .asciiz "The IP address you entered: "
	STR_DOT: .asciiz "."
	STR_CLASSA: .asciiz "\n\nclass A address"
	STR_CLASSB: .asciiz "\n\nclass B address"
	STR_CLASSC: .asciiz "\n\nclass C address"
	STR_CLASSD: .asciiz "\n\nclass D address"
	STR_CLASSE: .asciiz "\n\nclass E address"
	STR_FOUND: .asciiz "\nMatching domain found at: "
	STR_NOTFOUND: .asciiz "\nMatching domain was NOT found .."
		

IP_ROUTING_TABLE_SIZE:
		.word	10

IP_ROUTING_TABLE:
		# line #, x.x.x.x -------------------------------------
		.word	0, 146, 163, 255, 255	# 146.163.255.255
		.word	1, 147, 163, 255, 255	# 147.163.255.255
		.word	2, 201,  88,  88,  90	# 201.88.88.90
		.word	3, 182, 151,  44,  56	# 182.151.44.56
		.word	4,  24, 125, 100, 100	# 24.125.100.100
		.word	10, 146, 163, 140,  80	# 146.163.170.80
		.word	11, 146, 163, 147,  80	# 146.163.147.80
		.word	12, 146, 164, 147,  80	# 146.164.147.80
		.word	13, 148, 163, 170,  80	# 146.163.170.80
		.word	14, 193,  77,  77,  10	# 193.77.77.10

.text
	.globl main

main:	

	PROMPT:		li $v0, 4			# system call for print string
			la $a0, STR_IPPROMPT		# specify IP prompt
			syscall				# displays IP prompt

	FIRST:		li $v0, 4			# system call for print string
			la $a0, STR_FIRST		# specify first prompt
			syscall				# displays first prompt

			li $v0, 5			# system call for read_int
			syscall				# get int from user
			move $t0, $v0			# move user int into t0

			li $t1, 255			# load 255 into t1
			bgt $t0, $t1, INVALNUM1		# if t0 > 255, jump to INVALNUM1

			li $t2, 1			# load 1 into t2
			blt $t0, $t2, INVALNUM1		# if t0 < 1, jump to INVALNUM1

			move $s0, $t0			# move validated input from t0 to s0
			j SECOND			# jump to SECOND

	INVALNUM1:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify error message
			syscall				# displays error message

			j FIRST				# jumps to first prompt again

	SECOND:		li $v0, 4			# system call for print string
			la $a0, STR_SECOND		# specify second prompt
			syscall				# displays second prompt

			li $v0, 5			# system call for read_int
			syscall				# get int from user
			move $t0, $v0			# move user int into t0

			bgt $t0, $t1, INVALNUM2		# if t0 > 255, jump to INVALNUM2
			blt $t0, $t2, INVALNUM2		# if t0 < 1, jump to INVALNUM2

			move $s1, $t0			# move validated input from t0 to s1
			j THIRD				# jump to THIRD

	INVALNUM2:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify error message
			syscall				# displays error message

			j SECOND			# jumps to second prompt again

	THIRD:		li $v0, 4			# system call for print string
			la $a0, STR_THIRD		# specify third prompt
			syscall				# displays third prompt

			li $v0, 5			# system call for read_int
			syscall				# get int from user
			move $t0, $v0			# move user int into t0

			bgt $t0, $t1, INVALNUM3		# if t0 > 255, jump to INVALNUM3
			blt $t0, $t2, INVALNUM3		# if t0 < 1, jump to INVALNUM3

			move $s2, $t0			# move validated input from t0 to s2
			j FOURTH			# jump to FOURTH

	INVALNUM3:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify error message
			syscall				# displays error message

			j THIRD				# jumps to third prompt again

	FOURTH:		li $v0, 4			# system call for print string
			la $a0, STR_FOURTH		# specify fourth prompt
			syscall				# displays fourth prompt

			li $v0, 5			# system call for read_int
			syscall				# get int from user
			move $t0, $v0			# move user int into t0

			bgt $t0, $t1, INVALNUM4		# if t0 > 255, jump to INVALNUM4
			blt $t0, $t2, INVALNUM4		# if t0 < 1, jump to INVALNUM4

			move $s3, $t0			# move validated input from t0 to s3
			j IPDISPLAY			# jump to IPDISPLAY

	INVALNUM4:	li $v0, 4			# system call for print string
			la $a0, STR_INVALINPUT		# specify error message
			syscall				# displays error message

			j FOURTH			# jumps to fourth prompt again

	IPDISPLAY:	li $v0, 4			# system call for print string
			la $a0, STR_IP			# specify IP string
			syscall				# displays IP string

			li $v0, 1			# system call for print int
			move $a0, $s0			# specify first number
			syscall				# displays first number

			li $v0, 4			# system call for print string
			la $a0, STR_DOT			# specify dot string
			syscall				# displays dot string

			li $v0, 1			# system call for print int
			move $a0, $s1			# specify second number
			syscall				# displays second number

			li $v0, 4			# system call for print string
			la $a0, STR_DOT			# specify dot string
			syscall				# displays dot string

			li $v0, 1			# system call for print int
			move $a0, $s2			# specify third number
			syscall				# displays third number

			li $v0, 4			# system call for print string
			la $a0, STR_DOT			# specify dot string
			syscall				# displays dot string

			li $v0, 1			# system call for print int
			move $a0, $s3			# specify fourth number
			syscall				# displays fourth number

	CLASS:		li $t0, 128			# load 128 into t0
			blt $s0, $t0, CLASSA		# if s0 < 128, jump to CLASSA

			li $t0, 192			# load 192 into t0
			blt $s0, $t0, CLASSB		# if s0 < 192, jump to CLASSB

			li $t0, 224			# load 224 into t0
			blt $s0, $t0, CLASSC		# if s0 < 224, jump to CLASSC

			li $t0, 240			# load 240 into t0
			blt $s0, $t0, CLASSD		# if s0 < 240, jump to CLASSD
			j CLASSE			# else jump to CLASSE

	CLASSA:		li $v0, 4			# system call for print string
			la $a0, STR_CLASSA		# specify class A message
			syscall				# displays class A message

			j IPCHECK			# jump to IPCHECK

	CLASSB:		li $v0, 4			# system call for print string
			la $a0, STR_CLASSB		# specify class B message
			syscall				# displays class B message

			j IPCHECK			# jump to IPCHECK

	CLASSC:		li $v0, 4			# system call for print string
			la $a0, STR_CLASSC		# specify class C message
			syscall				# displays class C message

			j IPCHECK			# jump to IPCHECK

	CLASSD:		li $v0, 4			# system call for print string
			la $a0, STR_CLASSD		# specify class D message
			syscall				# displays class D message
			j IPCHECK			# jump to IPCHECK

	CLASSE:		li $v0, 4			# system call for print string
			la $a0, STR_CLASSE		# specify class E message
			syscall				# displays class E message

			j IPCHECK			# jump to IPCHECK

	IPCHECK:	li $s4, 0			# s4 will be our line counter and loop incrementor
			la $s5, IP_ROUTING_TABLE	# s5 will be our working pointer to the IP table
			li $s6, 10			# s6 will store our loop terminating value

	LOOP:		lw $s7, ($s5)			# loads the line # from the table into s7
			addu $s5, $s5, 4		# moves working pointer to first # on this line
			lw $t0, ($s5)			# loads # from working pointer into t0
			beq $s0, $t0, CHECK2		# if s0 = t0, move to CHECK2
			addu $s5, $s5, 16		# else move pointer to next line
			j LOOPEND			# jump to LOOPEND

	CHECK2:		addu $s5, $s5, 4		# moves working pointer to second # on this line
			lw $t0, ($s5)			# loads # from working pointer to t0
			beq $s1, $t0, FOUND		# if s1 = t0, move to FOUND
			addu $s5, $s5, 12		# else move pointer to next line
			j LOOPEND			# jump to LOOPEND

	LOOPEND:	addi $s4, $s4, 1		# adds 1 to loop incrementor/line counter
			beq $s4, $s6, NOTFOUND		# terminates loop if incrementor = terminating value
			j LOOP				# else start LOOP again

	FOUND:		li $v0, 4			# system call for print string
			la $a0, STR_FOUND		# specify found string
			syscall				# displays found string

			li $v0, 1			# system call for print int
			move $a0, $s7			# specify table line #
			syscall				# displays table line #

			jr $31				# return to main		

	NOTFOUND:	li $v0, 4			# system call for print string
			la $a0, STR_NOTFOUND		# specify not found string
			syscall				# displays not found string

			jr $31				# return to main	

# s0 = first IP # entered
# s1 = second IP # entered
# s2 = third IP # entered
# s3 = fourth IP # entered
# s4 = loop incrementor/IP table line counter
# s5 = working pointer to IP table
# s6 = loop terminating value
# s7 = table line #
# t0 & t1 = working values
