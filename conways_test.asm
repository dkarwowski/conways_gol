
#################################################################################################
#                               Unit Tests for Conway's Game of Life							#
#																								#
#  Padraic Edgington                                                     	     29 Apr, 2013	#
#																								#
#                                               v. 1.2											#
#																								#
#  You should write your code in a seperate file and prepend it to this file by running			#
#  either:																						#
#  Windows: copy /Y <Life Function Name>.asm + "Program #9 - Visualization.asm" <output>.asm	#
#  Unix:    cat <Life Function Name>.asm "Program #9 - Visualization.asm" > <output>.asm		#
#																								#
#  v. 1		Initial release																		#
#  v. 1.1	Added the rest of the glider sequence and bad data tests							#
#  v. 1.2	Fixed a bug in the test suite and made the error messages more descriptive.			#
#################################################################################################

				.data
Block_State_0:	.word	4, 4
				.byte	0x06, 0x60
Loaf_State_0:	.word	6, 6
				.byte	0x00, 0xC4, 0x8A, 0x10, 0x00

Toad_State_1:	.word	6, 6
				.byte	0x00, 0x03, 0x9C, 0x00, 0x00
Toad_State_2:	.word	6, 6
				.byte	0x00, 0x44, 0x92, 0x20, 0x00

Glider_State_1:	.word	5, 5
				.byte	0x01, 0x04, 0xE0, 0x00
Glider_State_2:	.word	5, 5
				.byte	0x00, 0x14, 0x62, 0x00
Glider_State_3:	.word	5, 5
				.byte	0x00, 0x04, 0xA3, 0x00
Glider_State_4:	.word	5, 5
				.byte	0x00, 0x08, 0x33, 0x00
Glider_State_5:	.word	5, 5
				.byte	0x00, 0x04, 0x13, 0x80
Glider_State_6:	.word	5, 5
				.byte	0x10, 0x00, 0x51, 0x80
Glider_State_7:	.word	5, 5
				.byte	0x18, 0x00, 0x12, 0x80
Glider_State_8:	.word	5, 5
				.byte	0x18, 0x00, 0x28, 0x80
Glider_State_9:	.word	5, 5
				.byte	0x98, 0x00, 0x18, 0x00
Glider_State_10:.word	5, 5
				.byte	0x88, 0x40, 0x09, 0x00
Glider_State_11:.word	5, 5
				.byte	0x94, 0x40, 0x08, 0x00
Glider_State_12:.word	5, 5
				.byte	0xC4, 0x40, 0x00, 0x80
Glider_State_13:.word	5, 5
				.byte	0x46, 0x40, 0x08, 0x00
Glider_State_14:.word	5, 5
				.byte	0x4E, 0x20, 0x00, 0x00
Glider_State_15:.word	5, 5
				.byte	0x42, 0x70, 0x00, 0x00
Glider_State_16:.word	5, 5
				.byte	0x83, 0x30, 0x00, 0x00
Glider_State_17:.word	5, 5
				.byte	0x41, 0x38, 0x00, 0x00
Glider_State_18:.word	5, 5
				.byte	0x05, 0x18, 0x80, 0x00
Glider_State_19:.word	5, 5
				.byte	0x01, 0x28, 0xC0, 0x00
Glider_State_20:.word	5, 5
				.byte	0x02, 0x0C, 0xC0, 0x00
				.text

main:	addi	$sp, $sp, -12			#  Make space for the $ra and the life pointer on the stack
		sw		$ra, 4 ($sp)			#  Store the return address on the stack
		sw		$gp, 8 ($sp)			#  Store the address for the top of the heap.


###############################################################################
##                        Testing Conway's Game of Life                      ##
###############################################################################
		#  Test #1
		#  Block
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Block_State_0		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Block_State_0		#  Expected result
		li		$a3, 1					#  Test #1
		jal		assertEqualLife			#  Check for equal life objects
		

		#  Test #2
		#  Loaf
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Loaf_State_0		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Loaf_State_0		#  Expected result
		li		$a3, 2					#  Test #2
		jal		assertEqualLife			#  Check for equal life objects
		

		#  Test #3
		#  Toad #1
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Toad_State_1		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Toad_State_2		#  Expected result
		li		$a3, 3					#  Test #2
		jal		assertEqualLife			#  Check for equal life objects
		

		#  Test #4
		#  Toad #2
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Toad_State_2		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Toad_State_1		#  Expected result
		li		$a3, 4					#  Test #4
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #5
		#  Glider #1
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_1		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_2		#  Expected result
		li		$a3, 5					#  Test #5
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #6
		#  Glider #2
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_2		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_3		#  Expected result
		li		$a3, 6					#  Test #6
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #7
		#  Glider #3
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_3		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_4		#  Expected result
		li		$a3, 7					#  Test #7
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #8
		#  Glider #4
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_4		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_5		#  Expected result
		li		$a3, 8					#  Test #8
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #9
		#  Glider #5
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_5		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_6		#  Expected result
		li		$a3, 9					#  Test #9
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #10
		#  Glider #6
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_6		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_7		#  Expected result
		li		$a3, 10					#  Test #10
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #11
		#  Glider #7
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_7		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_8		#  Expected result
		li		$a3, 11					#  Test #11
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #12
		#  Glider #8
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_8		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_9		#  Expected result
		li		$a3, 12					#  Test #12
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #13
		#  Glider #9
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_9		#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_10	#  Expected result
		li		$a3, 13					#  Test #13
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #14
		#  Glider #10
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_10	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_11	#  Expected result
		li		$a3, 14					#  Test #14
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #15
		#  Glider #11
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_11	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_12	#  Expected result
		li		$a3, 15					#  Test #15
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #16
		#  Glider #12
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_12	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_13	#  Expected result
		li		$a3, 16					#  Test #16
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #17
		#  Glider #13
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_13	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_14	#  Expected result
		li		$a3, 17					#  Test #17
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #18
		#  Glider #14
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_14	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_15	#  Expected result
		li		$a3, 18					#  Test #18
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #19
		#  Glider #15
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_15	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_16	#  Expected result
		li		$a3, 19					#  Test #19
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #20
		#  Glider #16
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_16	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_17	#  Expected result
		li		$a3, 20					#  Test #20
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #21
		#  Glider #17
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_17	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_18	#  Expected result
		li		$a3, 21					#  Test #21
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #22
		#  Glider #18
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_18	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_19	#  Expected result
		li		$a3, 22					#  Test #22
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #23
		#  Glider #19
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_19	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_20	#  Expected result
		li		$a3, 23					#  Test #23
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #24
		#  Glider #20
		#  Returns to the original glider state.
		#######################################################################
		jal		setSavedRegisters
		la		$a0, Glider_State_20	#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		la		$a1, Glider_State_1		#  Expected result
		li		$a3, 24					#  Test #24
		jal		assertEqualLife			#  Check for equal life objects
		
		
		#  Test #25
		#  Null pointer check
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0					#  Life object (null pointer)
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (another null pointer)
		li		$a3, 25					#  Test #25
		jal		assertEqual				#  Check for equality
		
		
		#  Test #26
		#  Negative address check #1
		#######################################################################
		jal		setSavedRegisters
		li		$a0, -1					#  Life object (bad pointer)
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 26					#  Test #26
		jal		assertEqual				#  Test for equality
		
		
		#  Test #27
		#  Negative address check #2
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x80000000			#  Life object (bad pointer)
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 27					#  Test #27
		jal		assertEqual				#  Test for equality
		
		
		#  Test #28
		#  Unaligned address check #1
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10010001			#  Life object (bad pointer)
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 28					#  Test #28
		jal		assertEqual				#  Test for equality
		
		
		#  Test #29
		#  Unaligned address check #2
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10010002			#  Life object (bad pointer)
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 29					#  Test #29
		jal		assertEqual				#  Test for equality
		
		
		#  Test #30
		#  Unaligned address check #3
		#######################################################################
		jal		setSavedRegisters
		li		$a0, 0x10010003			#  Life object (bad pointer)
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 30					#  Test #30
		jal		assertEqual				#  Test for equality
		
		
		#  Test #31
		#  0 rows in object
		#######################################################################
		.data
bad1:	.word	0, 5
		.byte	0x00, 0x00, 0x00, 0x00
		.text
		jal		setSavedRegisters
		la		$a0, bad1				#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 31					#  Test #31
		jal		assertEqual				#  Test for equality
		
		
		#  Test #32
		#  0 columns in object
		#######################################################################
		.data
bad2:	.word	5, 0
		.byte	0x00, 0x00, 0x00, 0x00
		.text
		jal		setSavedRegisters
		la		$a0, bad2				#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 32					#  Test #32
		jal		assertEqual				#  Test for equality
		
		
		#  Test #33
		#  0 rows and columns in object
		#######################################################################
		.data
bad3:	.word	0, 0
		.byte	0x00, 0x00, 0x00, 0x00
		.text
		jal		setSavedRegisters
		la		$a0, bad3				#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 33					#  Test #33
		jal		assertEqual				#  Test for equality
		
		
		#  Test #34
		#  Negative # of rows
		#######################################################################
		.data
bad4:	.word	-6, 5
		.byte	0x00, 0x00, 0x00, 0x00
		.text
		jal		setSavedRegisters
		la		$a0, bad4				#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 34					#  Test #34
		jal		assertEqual				#  Test for equality
		
		
		
		#  Test #35
		#  Negative # of columns
		#######################################################################
		.data
bad5:	.word	5, -3
		.byte	0x00, 0x00, 0x00, 0x00
		.text
		jal		setSavedRegisters
		la		$a0, bad5				#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 35					#  Test #35
		jal		assertEqual				#  Test for equality
		
		
		#  Test #36
		#  Negative # of rows and columns
		#######################################################################
		.data
bad6:	.word	-2, -4
		.byte	0x00, 0x00, 0x00, 0x00
		.text
		jal		setSavedRegisters
		la		$a0, bad6				#  Life object
		jal		Life					#  Get next state
		
		move	$a0, $v0				#  Result
		li		$a1, 0					#  Expected result (null pointer)
		li		$a3, 36					#  Test #36
		jal		assertEqual				#  Test for equality
		
		
		#  Completed Tests
		#######################################################################
		lw		$ra, 4 ($sp)			#  Load return address
		addi	$sp, $sp, 12			#  Pop the stack
		jr		$ra

		
###############################################################################
##                            Assertion functions                            ##
###############################################################################
		.data
a1:		.asciiz	"Test #"
a2:		.asciiz	" passed.\n"
a3:		.asciiz	" failed.  The result should not have been "
a4:		.asciiz	" has changed a saved register without restoring it.\n"
a5:		.asciiz	".\n"
a6:		.asciiz	" failed:  Observed value:  0x"
a7:		.asciiz "\tExpected value:  0x"
a8:		.asciiz	" failed:  Observed value:  "
a9:		.asciiz "\tExpected value:  "
		.text
		
		#  Assert Equality
		#
		#  Parameters:
		#  a0:  Observed value
		#  a1:  Desired value
		#  a3:  Test #
		#######################################################################
assertEqual:
		addi	$sp, $sp, -16
		sw		$a0,  0 ($sp)			#  Store the observed value
		sw		$a1,  4 ($sp)			#  Store the desired value
		sw		$a3,  8 ($sp)			#  Store the test #
		sw		$ra, 12 ($sp)			#  Store the return address
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  8 ($sp)
		syscall
		
		#  Perform the checks for the assertion
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		bne		$t0, $t1, AE_Fail		#  If the result is not equal to the desired value, then FAIL
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		beqz	$v0, AE_Pass			#  If everything checks out, then PASS
		
		
		#  If the saved registers were tampered with...
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test


		#  If the assertion passed...
AE_Pass:
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		
		
		#  If the assertion failed...
AE_Fail:
		li		$v0, 4
		la		$a0, a8
		syscall							#  Print " failed:  Observed value:  "
		li		$v0, 1
		lw		$a0,  0 ($sp)
		syscall							#  Print observed value
		li		$v0, 4
		la		$a0, a9
		syscall							#  Print "\tExpected value:  "
		li		$v0, 1
		lw		$a0,  4 ($sp)
		syscall							#  Print desired value
		li		$v0, 4
		la		$a0, a5
		syscall							#  Print ".\n"
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		#######################################################################

		
		
		#  Assert Inequality
		#
		#  Parameters:
		#  a0:  Observed value
		#  a1:  Undesired value
		#  a3:  Test #
		#######################################################################
assertNotEqual:
		addi	$sp, $sp, -16
		sw		$a0,  0 ($sp)			#  Store the observed value
		sw		$a1,  4 ($sp)			#  Store the undesired value
		sw		$a3,  8 ($sp)			#  Store the test #
		sw		$ra, 12 ($sp)			#  Store the return address
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  8 ($sp)
		syscall
		
		#  Perform the checks for the assertion
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		beq		$t0, $t1, ANE_Fail		#  If the result is equal to the undesired value, then FAIL
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		beqz	$v0, ANE_Pass			#  If everything checks out, then PASS
		
		
		#  If the saved registers were tampered with...
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test


		#  If the assertion passed...
ANE_Pass:
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		
		
		#  If the assertion failed...
ANE_Fail:
		li		$v0, 4
		la		$a0, a3
		syscall							#  Print " failed.  The result should not have been "
		li		$v0, 1
		lw		$a0,  4 ($sp)
		syscall							#  Print undesired value
		li		$v0, 4
		la		$a0, a5
		syscall
		lw		$ra, 12 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		#######################################################################

		
		
		#  Assert 64-bit Equality
		#
		#  Parameters:
		#  a0:  Observed upper 32 bits
		#  a1:  Observed lower 32 bits
		#  a2:  Desired  upper 32 bits
		#  a3:  Desired  lower 32 bits
		#  $sp-4:  Test #
		#######################################################################
assertEqual_64:
		addi	$sp, $sp, -24
		sw		$a0,  0 ($sp)			#  Observed upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed lower 32 bits
		sw		$a2,  8 ($sp)			#  Desired  upper 32 bits
		sw		$a3, 12 ($sp)			#  Desired  lower 32 bits
		sw		$ra, 16 ($sp)			#  Return address
		#  Test # is at 20 ($sp)
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  20 ($sp)
		syscall
		
		
		#  Check for 64-bit equality
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		
		bne		$t0, $t2, AE64_Fail		#  If the upper 32 bits are not equal, then FAIL
		bne		$t1, $t3, AE64_Fail		#  If the lower 32 bits are not equal, then FAIL
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		beqz	$v0, AE64_Pass			#  If everything checks out, then PASS

		
		#  If the saved registers were tampered with...
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test


		#  If the assertion passed...
AE64_Pass:
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		
		
		#  If the two 64-bit numbers are not equal...
AE64_Fail:
		li		$v0, 4
		la		$a0, a6
		syscall							#  Print " failed:  Observed value:  "
		lw		$a0,  0 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall							#  Print a space after the first eight characters
		lw		$a0,  4 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, a7
		syscall							#  Print "\tExpected value:  "
		lw		$a0,  8 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall							#  Print a space after the first eight characters
		lw		$a0, 12 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, a5					#  Print ".\n"
		syscall
		
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		#######################################################################
		
		
		
		
		#  Assert 64-bit Inequality
		#
		#  Parameters:
		#  a0:  Observed  upper 32 bits
		#  a1:  Observed  lower 32 bits
		#  a2:  Undesired upper 32 bits
		#  a3:  Undesired lower 32 bits
		#  $sp-4:  Test #
		#######################################################################
assertNotEqual_64:
		addi	$sp, $sp, -24
		sw		$a0,  0 ($sp)			#  Observed  upper 32 bits
		sw		$a1,  4 ($sp)			#  Observed  lower 32 bits
		sw		$a2,  8 ($sp)			#  Undesired upper 32 bits
		sw		$a3, 12 ($sp)			#  Undesired lower 32 bits
		sw		$ra, 16 ($sp)			#  Return address
		#  Test # is at 20 ($sp)
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  20 ($sp)
		syscall
		
		
		#  Check for 64-bit inequality
		lw		$t0,  0 ($sp)
		lw		$t1,  4 ($sp)
		lw		$t2,  8 ($sp)
		lw		$t3, 12 ($sp)
		
		bne		$t0, $t2, ANE64_Pass	#  If the upper 32 bits are not equal, then PASS
		bne		$t1, $t3, ANE64_Pass	#  If the lower 32 bits are not equal, then PASS
		
		#  If the two 64-bit numbers are equal, then FAIL
		li		$v0, 4
		la		$a0, a3
		syscall
		lw		$a0, 8 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, nbsp
		syscall							#  Print a space after the first eight characters
		lw		$a0, 12 ($sp)
		jal		printHexadecimal
		li		$v0, 4
		la		$a0, a5					#  Print ".\n"
		syscall
		
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		
		
		#  If the two 64-bit numbers are not equal...
ANE64_Pass:
		jal		checkSavedRegisters		#  Check to make sure that the saved registers have not been tampered with (or at least have been restored)
		bnez	$v0, ANE64_Saved_Fail	#  If the result is not zero, then FAIL

		#  If everything checks out, then PASS
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		

		#  If the saved registers were tampered with...
ANE64_Saved_Fail:
		li		$v0, 4
		la		$a0, a4
		syscall							#  Print saved register FAIL
		lw		$ra, 16 ($sp)
		addi	$sp, $sp, 24
		jr		$ra						#  Return to calling test
		#######################################################################
		
		
		
		
		#  Assert Equal Life Objects
		#
		#  Parameters:
		#  $a0:  observed object
		#  $a1:  desired object
		#  $a3:  test #
		#######################################################################
assertEqualLife:
		addi	$sp, $sp, -16
		sw		$ra,  0 ($sp)
		sw		$a0,  4 ($sp)
		sw		$a1,  8 ($sp)
		sw		$a3, 12 ($sp)
		
		#  Print the test #
		li		$v0, 4
		la		$a0, a1
		syscall
		li		$v0, 1
		lw		$a0,  12 ($sp)
		syscall
		
		#  Check for accessable object
		lw		$a0, 4 ($sp)
		beq		$a0, $0, AEL_Null_Pointer
		li		$t0, 0x7FFFFFF8
		bgeu	$a0, $t0, AEL_Out_of_Bounds
		lw		$t0, 24 ($sp)
		blt		$a0, $t0, AEL_Not_New_Object
		
		#  Compare sizes
		lw		$a0, 4 ($sp)
		lw		$a1, 8 ($sp)
		lw		$t0, 0 ($a0)
		lw		$t1, 0 ($a1)
		bne		$t0, $t1, AEL_Size_Mismatch
		lw		$t0, 4 ($a0)
		lw		$t1, 4 ($a1)
		bne		$t0, $t1, AEL_Size_Mismatch
		
		#  Compare data
		lw		$t0, 0 ($a0)
		lw		$t1, 4 ($a0)
		mul		$t2, $t0, $t1
		li		$t3, 8
		div		$t2, $t3
		mflo	$t3							#  Calculate size of the data
		mfhi	$t4
		beq		$t4, $0, AEL_Mod_Zero
		addi	$t3, $t3, 1					#  Add one for part of a byte
AEL_Mod_Zero:
		li		$t4, 0
AEL_Loop:									#  Check one byte from each object at a time
		add		$t6, $t4, $a0
		lbu		$t5, 8 ($t6)
		add		$t6, $t4, $a1
		lbu		$t6, 8 ($t6)
		bne		$t5, $t6, AEL_Bad_Data
		
		addi	$t4, $t4, 1
		blt		$t4, $t3, AEL_Loop
		
		#  If all elements are equal, then the objects are equal
		li		$v0, 4
		la		$a0, a2
		syscall							#  Print " passed.\n"
		lw		$ra,  0 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		
		
		#  If the assertion failed...
		.data	#  Error messages
AEL_NP:	.asciiz	" failed.  Null pointer received.\n"
AEL_OB:	.asciiz	" failed.  Object is outside of the allowable memory range.\n"
AEL_SM:	.asciiz	" failed.  Incorrect array size.\n"
AEL_BD:	.asciiz " failed.  The array is incorrect.\n"
AEL_NO:	.asciiz " failed.  The object was not newly created.\n"
		.text
AEL_Null_Pointer:
		la		$a0, AEL_NP
		j		AEL_Fail
AEL_Out_of_Bounds:
		la		$a0, AEL_OB
		j		AEL_Fail
AEL_Size_Mismatch:
		la		$a0, AEL_SM
		j		AEL_Fail
AEL_Bad_Data:
		la		$a0, AEL_BD
		j		AEL_Fail
AEL_Not_New_Object:
		la		$a0, AEL_NO
		j		AEL_Fail
AEL_Fail:
		li		$v0, 4
		syscall							#  Print " failed.\n"
		lw		$ra,  0 ($sp)
		addi	$sp, $sp, 16
		jr		$ra						#  Return to calling test
		
		#######################################################################
		
		
		
		
		#  Check Saved Registers
		#
		#  Results:
		#  $v0:  0 if saved registers were not modified, else 1
		#######################################################################
checkSavedRegisters:
		bne		$s0, 14, regFail
		bne		$s1, 73, regFail
		bne		$s2, 69, regFail
		bne		$s3, 46, regFail
		bne		$s4, 79, regFail
		bne		$s5, 92, regFail
		bne		$s6, 37, regFail
		bne		$s7, 96, regFail
		li		$v0, 0
		jr		$ra

regFail:
		li		$v0, 1
		jr		$ra					#  Return to caller
		#######################################################################
		

		#  Set Saved Registers
		#######################################################################
setSavedRegisters:
		li		$s0, 14
		li		$s1, 73
		li		$s2, 69
		li		$s3, 46
		li		$s4, 79
		li		$s5, 92
		li		$s6, 37
		li		$s7, 96
		jr		$ra
		#######################################################################
		
		
		
		#  Print Hexadecimal Number
		#
		#      This function takes a 32-bit integer as a parameter and prints
		#  it to the console in hexadecimal format.
		#
		#  Parameters:
		#  $a0:  32-bit number
		#######################################################################
		.data
hex:	.ascii	"0123456789ABCDEF"
nbsp:	.asciiz	" "
		.text
printHexadecimal:
		addi	$sp, $sp, -4
		sw		$s0, 0 ($sp)
		move	$s0, $a0


		#  Use a mask to select four bits at a time; move the selected four bits
		#  into the least significant bit positions and use them as an index to
		#  select a hexadecimal character from the hex array and print the character.
		li		$t0, 0				#  Counter
HexLoop:
		bge		$t0, 32, HexEndLoop
		li		$a0, 0xF0000000
		srlv	$a0, $a0, $t0		#  Create a mask for the current 4 bits
		and		$a0, $a0, $s0		#  Apply the mask
		li		$t1, 28
		sub		$t1, $t1, $t0
		srlv	$a0, $a0, $t1		#  Shift the selected 4 bits into the LSB positions
		la		$t1, hex
		add		$a0, $t1, $a0
		lbu		$a0, 0 ($a0)		#  Read the indexed character from the string
		li		$v0, 11
		syscall						#  Print the selected character
		addi	$t0, $t0, 4			#  Increment to the next four bits
		bne		$t0, 16, HexLoop
		li		$v0, 4
		la		$a0, nbsp
		syscall						#  Print a space after the first four characters
		j		HexLoop
		
		
HexEndLoop:
		lw		$s0, 0 ($sp)
		addi	$sp, $sp, 4
		jr		$ra