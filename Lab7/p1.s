.text

## bool has_single_bit_set(unsigned value) {  // returns 1 if a single bit is set
##   if (value == 0) {  
##     return 0;   // has no bits set
##   }
##   if (value & (value - 1)) {
##     return 0;   // has more than one bit set
##   }
##   return 1;
## }

.globl has_single_bit_set
has_single_bit_set:
	add $t1, $a0, 0
	li   $t2, 0
	beq  $t1, $t2, if_state_1
	beq  $t1, 0x80000000, true_case
	sub  $t3, $t1, 1
	and  $t4, $t3, $t1
	bne  $t4, $t2, if_state_2
	j	 true_case

true_case:
	li   $v0, 1
	jr	 $ra

if_state_1:
	li   $v0, 0
	jr   $ra

if_state_2:
	li   $v0, 0
	jr   $ra

## unsigned get_lowest_set_bit(unsigned value) {
##   for (int i = 0 ; i < 16 ; ++ i) {
##     if (value & (1 << i)) {          # test if the i'th bit position is set
##       return i;                      # if so, return i
##     }
##   }
##   return 0;
## }

.globl get_lowest_set_bit
get_lowest_set_bit:
	add  $t1, $a0, 0    #t1 stores value
	add  $t2, $zero, 0  #t2 stores i
	add  $t3, $zero, 1  #t3 stores 1 
	add  $t6, $zero, 16 #t6 stores 16
loop:
	add  $t4, $t3, 0	#t4 stores 1<<i
	sll  $t4, $t4, $t2
	and  $t5, $t4, $t1	#t5 stores and result
	bne  $t5, $zero, if_state
	add  $t2, $t2, 1 	
	beq  $t2, $t6, done_loop
	j    loop

done_loop:
	li   $v0, 0
	jr	 $ra

if_state:
	add  $v0, $t2, 0		#v0 = i
	jr   $ra

