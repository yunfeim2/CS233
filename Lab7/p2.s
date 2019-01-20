.text 

## bool
## board_done(unsigned short board[16][16]) {
##   for (int i = 0 ; i < 16 ; ++ i) {
##     for (int j = 0 ; j < 16 ; ++ j) {
##       if (!has_single_bit_set(board[i][j])) {
##         return false;
##       }
##     }
##   }
##   return true;
## }

.globl board_done
board_done:
	sub  $sp, $sp, 20
	add  $t1, $zero, 512	#when to jump out
	add  $t2, $zero, 0		#offset
	add  $t3, $a0, 0		#store board
	sw	 $a0, 16($sp)		#store a0
	sw	 $ra, 0($sp)		#store ra
	sw	 $t1, 4($sp)		#store when to jump out
	sw	 $t3, 12($sp)		#store a0
	j 	 loop

loop:
	sw	 $t2, 8($sp)		#store offset
	add  $t9, $t2, $t3
	lhu  $a0, 0($t9)		#find next board[i][j]
	jal	 has_single_bit_set	#call function


	beq  $v0, $zero, board_done_false	#if statement


	lw   $t1, 4($sp)		#load when to jump out
	lw   $t2, 8($sp)		#load offset
	lw   $t3, 12($sp)		#load board (start point of board[i][j])
	add	 $t2, $t2, 2			#offset to next
	beq  $t2, $t1, board_done_true 	#jump out(loop finish)
	j    loop				#back to next loop


board_done_false:
	lw   $a0, 16($sp)
	li   $v0, 0				#v0 = false
	lw 	 $ra, 0($sp)		#load ra
	add  $sp, $sp, 20
	jr   $ra


board_done_true:
	lw   $a0, 16($sp)
	li   $v0, 1				#v0 = true
	lw 	 $ra, 0($sp)		#load ra
	add  $sp, $sp, 20
	jr   $ra

	
## void
## print_board(unsigned short board[16][16]) {
##   for (int i = 0 ; i < 16 ; ++ i) {
##     for (int j = 0 ; j < 16 ; ++ j) {
##       int value = board[i][j];
##       char c = '*';
##       if (has_single_bit_set(value)) {
##         int num = get_lowest_set_bit(value) + 1;
##         c = symbollist[num];
##       }
##       putchar(c);
##     }
##     putchar('\n');
##   }
## }

.globl print_board
print_board:
	sub  $sp, $sp, 20
	add  $t1, $zero, 32 	#when to jump out
	add  $t2, $zero, 0		#offset1
	add  $t3, $a0, 0		#store board
	add  $s5, $zero, 0
	sw	 $a0, 16($sp)		#store a0
	sw	 $ra, 0($sp)		#store ra
	sw	 $t1, 4($sp)		#store when to jump out
	sw	 $t3, 12($sp)		#store a0
	j 	 loop1

loop1:
	sw	 $t2, 8($sp)		#store offset
	mul  $t8, $s5, 16
	add  $t8, $t8, $t2
	add  $t9, $t8, $t3
	lhu  $a0, 0($t9)		#find next board[i][j]
	li   $s0, '*'
	jal	 has_single_bit_set
	beq  $v0, $zero, print_star

	jal  get_lowest_set_bit
	add  $s1, $v0, 1
	la   $s0, symbollist
	add  $s1, $s0, $s1
	lb   $s0, 0($s1)
	j    print_star

print_star:

	li   $v0, 11
	move $a0, $s0
	syscall

	lw   $t1, 4($sp)		#load when to jump out
	lw   $t2, 8($sp)		#load offset
	lw   $t3, 12($sp)		#load board (start point of board[i][j])
	add	 $t2, $t2, 2		#offset to next
	beq  $t2, $t1, big_loop
	j    loop1				#back to next loop

big_loop:
	add  $s5, $s5, 2
	li   $v0, 11
	li   $s0, '\n'
	move $a0, $s0
	syscall
	beq  $s5, $t1, print_board_done
	move $t2, $zero
	j    loop1




print_board_done:
	lw   $a0, 16($sp)
	lw 	 $ra, 0($sp)		#load ra
	add  $sp, $sp, 20
	jr   $ra

