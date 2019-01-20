.text

## bool
## rule1(unsigned short board[GRID_SQUARED][GRID_SQUARED]) {
##   bool changed = false;
##   for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
##     for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
##       unsigned value = board[i][j];
##       if (has_single_bit_set(value)) {
##         for (int k = 0 ; k < GRID_SQUARED ; ++ k) {
##           // eliminate from row
##           if (k != j) {
##             if (board[i][k] & value) {
##               board[i][k] &= ~value;
##               changed = true;
##             }
##           }
##           // eliminate from column
##           if (k != i) {
##             if (board[k][j] & value) {
##               board[k][j] &= ~value;
##               changed = true;
##             }
##           }
##         }
## 
##         // elimnate from square
##         int ii = get_square_begin(i);
##         int jj = get_square_begin(j);
##         for (int k = ii ; k < ii + GRIDSIZE ; ++ k) {
##           for (int l = jj ; l < jj + GRIDSIZE ; ++ l) {
##             if ((k == i) && (l == j)) {
##               continue;
##             }
##             if (board[k][l] & value) {
##               board[k][l] &= ~value;
##               changed = true;
##             }
##           }
##         }
##       }
##     }
##   }
##   return changed;
## }

.globl rule1
rule1:
	sub $sp, $sp, 36 

	sw  $a0, 0($sp)
	sw  $ra, 4($sp)
	sw  $s1, 8($sp)
	sw  $s2, 12($sp)
	sw  $s3, 16($sp)
	sw  $s4, 20($sp)
	sw  $s5, 24($sp)
	sw  $s6, 28($sp)
	sw  $s7, 32($sp)


	li  $s1, 0       #s1 is i
	li  $s2, 0       #s2 saves changed, which equals to 0
	li  $s3, 0       #s3 is j
	
	j   loop

loop_outer:
	move $s3, $zero      #j=0
	add  $s1, $s1, 1     #i++
	beq  $s1, 16, return_state
	j    loop_1

loop_1:
	beq  $s1, 16, return_state
loop:
	beq  $s3, 16, loop_outer
	mul  $s4, $s1, 16      #s4 will be the current address
	add  $s4, $s4, $s3
	mul  $s4, $s4, 2
	add  $s4, $s4, $a0
	lhu  $s4, 0($s4)      #s4 is now board[i][j]
	move $a0, $s4        #a0 = value
	jal  has_single_bit_set   #if (has_single_bit_set(value))
	lw   $a0, 0($sp)
	bne  $v0, 0, if_state  
	j    back_to_loop

back_to_loop:
	add  $s3, $s3, 1	#count++
	j    loop



if_state:
	move $s5, $zero      #s5 is k
	j    if_state_loop
if_state_loop:
	beq  $s5, 16, if_state_loop_end
	bne  $s5, $s3, if_state_sub1
	j    back_to_if_state

if_state_sub1:
	move $t0, $s1			#t0 = i
	mul  $t0, $t0, 16
	add  $t0, $t0, $s5
	mul  $t0, $t0, 2
	lw   $a0, 0($sp)
	add  $t0, $a0, $t0
	move $t3, $t0
	lhu  $t0, 0($t0)
	and  $t1, $t0, $s4
	beq  $t1, $zero, back_to_if_state
	nor  $t2, $s4, $zero
	and  $t2, $t2, $t0      #t2 = board[i][k] & ~value;
	sh   $t2, 0($t3)		#board[i][k] = board[i][k] & ~value;
	add  $s2, $zero, 1   
	j    back_to_if_state


back_to_if_state:
	bne  $s5, $s1, if_state_sub2
	j    back_to_if_state2

if_state_sub2:
	move $t0, $s5			#t0 = k
	mul  $t0, $t0, 16		#t0 = k * 16
	add  $t0, $t0, $s3		#t0 = k * 16 + j
	mul  $t0, $t0, 2
	lw   $a0, 0($sp)		#t0 becomes the offset
	add  $t0, $a0, $t0		#t0 becomes the address of board[k][j]
	move $t3, $t0			#t3 saves the address of board[k][j]
	lhu  $t0, 0($t0)		#t0 = board[k][j]
	and  $t1, $t0, $s4		#t1 = board[k][j] & value
	beq  $t1, $zero, back_to_if_state2
	nor  $t2, $s4, $zero
	and  $t2, $t2, $t0      #t2 = board[i][k] & ~value;
	sh   $t2, 0($t3)		#board[i][k] = board[i][k] & ~value;
	add  $s2, $zero, 1              #change = 1
	j    back_to_if_state2

back_to_if_state2:
	add  $s5, $s5, 1
	j    if_state_loop

	



if_state_loop_end:
	move $a0, $s1    		#s6 stores ii
	jal  get_square_begin	
	move $s6, $v0
	move $a0, $s3			#s7 stores jj
	jal  get_square_begin
	move $s7, $v0
	lw   $a0, 0($sp)

	add  $t0, $zero, $s6	#t0 stores k = ii
	add  $t1, $zero, $s7	#t1 stores l = jj
	add  $t2, $s6, 4		#t2 stores ii + GRIDSIZE
	add  $t3, $s7, 4		#t3 stores jj + GRIDSIZE

	j    if_loop_2_1


if_loop_2_outer:
	add  $t1, $s7, 0
	add  $t0, $t0, 1
	j    if_loop_2_1

if_loop_2_1:
	beq  $t0, $t2, back_to_loop
if_loop_2:
	beq  $t1, $t3, if_loop_2_outer
	xor  $t4, $s1, $t0
	xor  $t5, $s3, $t1
	or   $t4, $t4, $t5
	beq  $t4, 0, if_loop_2_next
	move $t4, $t0
	mul  $t4, $t4, 16
	add  $t4, $t4, $t1
	mul  $t4, $t4, 2
	lw   $a0, 0($sp)
	add  $t4, $t4, $a0
	lhu  $t5, 0($t4)
	and  $t6, $t5, $s4
	beq  $t6, 0, if_loop_2_next
	nor  $t6, $s4, $zero
	and  $t6, $t6, $t5
	sh   $t6, 0($t4)
	li   $s2, 1

	j    if_loop_2_next

if_loop_2_next:
	add  $t1, $t1, 1
	j    if_loop_2


return_state:
	move $v0, $s2
	lw   $ra, 4($sp)
	lw   $s1, 8($sp)
	lw   $s2, 12($sp)
	lw   $s3, 16($sp)
	lw   $s4, 20($sp)
	lw   $s5, 24($sp)
	lw   $s6, 28($sp)
	lw   $s7, 32($sp)
	add  $sp, $sp, 36
	jr	 $ra

