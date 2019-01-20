.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

RIGHT_WALL_SENSOR 		= 0xffff0054
PICK_TREASURE           = 0xffff00e0
TREASURE_MAP            = 0xffff0058

REQUEST_PUZZLE          = 0xffff00d0
SUBMIT_SOLUTION         = 0xffff00d4

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

REQUEST_PUZZLE_INT_MASK = 0x800
REQUEST_PUZZLE_ACK      = 0xffff00d8
# struct spim_treasure
#{
#    short x;
#    short y;
#    int points;
#};
#
#struct spim_treasure_map
#{
#    unsigned length;
#    struct spim_treasure treasures[50];
#};
#

.data
.align 4


#REQUEST_PUZZLE returns an int array of length 128

#################################  array for puzzle  ##################################

puzzle_arr:
.word	0:127

#################################  array for puzzle  ##################################

dfs_solu:      
.word   128

path:
.word	2, 3, 0, 3, 0, 1, 0, 1, 2, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 3, 0, 3, 2, 3, 2, 1, 2, 1, 2, 2, 2, 2, 3, 3, 2, 2, 3, 3
.word   -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1

step_count:
.word   0

.text



#################################  MAIN  ##################################

.globl main
main:
	#Fill in your code here
    la      $t0, puzzle_arr                 #save the arr address to t0
    sw      $t0, REQUEST_PUZZLE             #write the address to I/O
    li      $t4, 0x8000                     # timer interrupt enable bit
    or      $t4, REQUEST_PUZZLE_INT_MASK    # puzzle interrupt enable bit
    or      $t4, 0x1000    # puzzle interrupt enable bit
    or      $t4, $t4, 1                     # global interrupt enable
    lw      $v0, 0xffff001c($0)             # read current time
    add     $v0, $v0, 200000                # add 200000 to current time
    sw      $v0, 0xffff001c($0) 
    li      $a0, 0
    sw      $a0, 0xffff0010($zero)          # set speed to 0
    

main1:
    li      $t4, 0x8000                     # timer interrupt enable bit
    or      $t4, REQUEST_PUZZLE_INT_MASK    # puzzle interrupt enable bit
    or      $t4, 0x1000    # puzzle interrupt enable bit
    or      $t4, $t4, 1                     # global interrupt enable
    mtc0    $t4, $12                        # set interrupt mask (Status register)
                                            # REQUEST TIMER INTERRUPT
    j       main1



#################################  MAIN  ##################################




.kdata
chunkIH:    .space 28
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at        # Save $at
.set at
        la        $k0, chunkIH
        sw        $a0, 0($k0)        # Get some free registers
        sw        $v0, 4($k0)        # by storing them to a global variable
        sw        $t0, 8($k0)
        sw        $t1, 12($k0)
        sw        $t2, 16($k0)
        sw        $t3, 20($k0)
        sw        $t4, 24($k0)
        sw        $t5, 28($k0)
        sw        $t6, 32($k0)
        sw        $t7, 36($k0)
        sw        $t8, 40($k0)
        sw        $t9, 44($k0)

        mfc0      $k0, $13             # Get Cause register
        srl       $a0, $k0, 2
        and       $a0, $a0, 0xf        # ExcCode field
        bne       $a0, 0, non_intrpt



interrupt_dispatch:            # Interrupt:
    mfc0       $k0, $13        # Get Cause register, again
    beq        $k0, 0, done        # handled all outstanding interrupts

    and        $a0, $k0, BONK_INT_MASK    # is there a bonk interrupt?
    bne        $a0, 0, bonk_interrupt

    and        $a0, $k0, TIMER_INT_MASK    # is there a timer interrupt?
    bne        $a0, 0, timer_interrupt

	and 	   $a0, $k0, REQUEST_PUZZLE_INT_MASK
	bne 	   $a0, 0, request_puzzle_interrupt

    li         $v0, PRINT_STRING    # Unhandled interrupt types
    la         $a0, unhandled_str
    syscall
    j    done

bonk_interrupt:
    #Fill in your code here
    sw       $zero, 0xffff0060($zero) # acknowledge interrupt
    j       interrupt_dispatch    # see if other interrupts are waiting

request_puzzle_interrupt:
	#Fill in your code here
    sw      $zero, REQUEST_PUZZLE_ACK         #ack puzzle interrupt
    la      $a0, puzzle_arr
    li      $a1, 1
    li      $a2, 1
    jal     dfs
    sw      $v0, dfs_solu
    la      $t2, dfs_solu
    sw      $t2, SUBMIT_SOLUTION
    la      $t0, puzzle_arr                 #save the arr address to  sound intuitive, this mat
    sw      $t0, REQUEST_PUZZLE             #write the address to I/O sound intuitive, this mat
    sw      $zero, REQUEST_PUZZLE_ACK

	j	    interrupt_dispatch


# print int and space ##################################################
#
# argument $a0: number to print

print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# main function ########################################################


#################################  DFS  ##################################
.globl dfs
dfs:
		sub		$sp, $sp, 16		# STACK STORE
		sw 		$ra, 0($sp)		# Store ra
		sw		$s0, 4($sp)		# s0 = tree
		sw		$s1, 8($sp)		# s1 = i
		sw		$s2, 12($sp)	# s2 = input
		move 	$s0, $a0
		move 	$s1, $a1
		move	$s2, $a2
		

##	if (i >= 127) {
##		return -1;
##	}

_dfs_base_case_one:
        blt     $s1, 127, _dfs_base_case_two	
        li      $v0, -1
        j _dfs_return


##	if (input == tree[i]) {
##		return 0;
##	}

_dfs_base_case_two:

		mul		$t1, $s1, 4
		add		$t2, $s0, $t1
        lw      $t1, 0($t2)  			# tree[i]
        
        bne     $t1, $s2, _dfs_ret_one
        li      $v0, 0
		j _dfs_return

##	int ret = DFS(tree, 2 * i, input);
##	if (ret >= 0) {
##		return ret + 1;
##	}
_dfs_ret_one:
		mul		$a1, $s1, 2
		jal 	dfs				##	int ret = DFS(tree, 2 * i, input);
        
	
		blt		$v0, 0, _dfs_ret_two	##	if (ret >= 0)500000
		
		addi	$v0, 1					##	return ret + 1
		j _dfs_return

##	ret = DFS(tree, 2 * i + 1, input);
##	if (ret >= 0) {
##		return ret + 1;
##	}
_dfs_ret_two:
        mul		$a1, $s1, 2
		addi	$a1, 1
		jal 	dfs				##	int ret = DFS(tree, 2 * i + 1, input);
        
	
		blt		$v0, 0, _dfs_return		##	if (ret >= 0)
		
		addi	$v0, 1					##	return ret + 1
		j _dfs_return

##	return ret;
_dfs_return:
		lw 		$ra, 0($sp)
		lw		$s0, 4($sp)
		lw		$s1, 8($sp)
		lw		$s2, 12($sp)
		add		$sp, $sp, 16
        jal     $ra

#################################  DFS  ##################################



timer_interrupt:
    #Fill in your code here
    sw      $zero, TIMER_ACK
    lw      $v0, 0xffff001c($0) # current time
    add     $v0, $v0, 20000
    sw      $v0, 0xffff001c($0) # request timer in 50000
    sw      $zero, PICK_TREASURE
    la      $t9, step_count
    lw      $t9, 0($t9)
    la      $t8, path
    move    $t4, $t9
    mul     $t4, $t4, 4
    add     $t4, $t4, $t8
    lw      $t4, 0($t4)
    add     $t9, $t9, 1
    bne     $t9, 40, jump_to_step
    li      $t9, 0

jump_to_step:
    sw      $t9, step_count

    beq     $t4, 0, turn_right
    beq     $t4, 1, turn_up
    beq     $t4, 2, turn_left
    beq     $t4, 3, turn_down
    j       interrupt_dispatch

turn_right:
    li      $t5, 1
    li      $t6, 0
    sw      $t6, ANGLE
    sw      $t5, ANGLE_CONTROL
    li      $a0, 5
    sw      $a0, 0xffff0010($zero)   # drive
    j       interrupt_dispatch    # see if other interrupts are waiting

turn_left:
    li      $t5, 1
    li      $t6, 180
    sw      $t6, ANGLE
    sw      $t5, ANGLE_CONTROL
    li      $a0, 5
    sw      $a0, 0xffff0010($zero)   # drive
    j       interrupt_dispatch    # see if other interrupts are waiting

turn_down:
    li      $t5, 1
    li      $t6, 90
    sw      $t6, ANGLE
    sw      $t5, ANGLE_CONTROL
    li      $a0, 5
    sw      $a0, 0xffff0010($zero)   # drive
    j       interrupt_dispatch    # see if other interrupts are waiting

turn_up:
    li      $t5, 1
    li      $t6, 270
    sw      $t6, ANGLE
    sw      $t5, ANGLE_CONTROL
    li      $a0, 5
    sw      $a0, 0xffff0010($zero)   # drive
    j       interrupt_dispatch    # see if other interrupts are waiting


non_intrpt:                # was some non-interrupt
    li        $v0, PRINT_STRING
    la        $a0, non_intrpt_str
    syscall                # print out an error message
    # fall through to done

done:
    la      $k0, chunkIH
    lw      $a0, 0($k0)        # Restore saved registers
    lw      $v0, 4($k0)
	lw      $t0, 8($k0)
    lw      $t1, 12($k0)
    lw      $t2, 16($k0)
    lw      $t3, 20($k0)
    lw      $t4, 24($k0)
    lw      $t5, 28($k0)
    lw      $t6, 32($k0)
    lw      $t7, 36($k0)
    lw      $t8, 40($k0)
    lw      $t9, 44($k0)

.set noat
    move    $at, $k1        # Restore $at
.set at
    eret

