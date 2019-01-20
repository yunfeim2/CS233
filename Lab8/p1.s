.text

##int 
##dfs(int* tree, int i, int input) {
##	if (i >= 127) {
##		return -1;
##	}
##	if (input == tree[i]) {
##		return 0;
##	}
##
##	int ret = DFS(tree, 2 * i, input);
##	if (ret >= 0) {
##		return ret + 1;
##	}
##	ret = DFS(tree, 2 * i + 1, input);
##	if (ret >= 0) {
##		return ret + 1;
##	}
##	return ret;
##}

.globl dfs
dfs:
	sub $sp, $sp, 24
	sw  $a1, 0($sp) #store i
	sw  $ra, 4($sp) #store ra
	sw  $s1, 8($sp)
	sw  $s2, 12($sp)
	sw  $s3, 16($sp)
	sw  $s4, 20($sp)

	add $s1, $a1, 0 #s1 stores a1
	bge $s1, 127, Base_1 #if(i >= 127)

	mul $s2, $s1, 4  #s2 is the address of tree[i]
	add $s2, $s2, $a0
	lw  $s3, 0($s2)
	beq $s3, $a2, Base_2

	mul $s1, $s1, 2
	add $a1, $s1, 0
	jal dfs
	add $s4, $v0, 0 #s4 stores ret
	bge $s4, 0, RET

	lw $a1 0($sp)
	mul $a1, $a1, 2
	add $a1, $a1, 1
	jal dfs
	add $s4, $v0, 0 #s4 stores ret
	bge $s4, 0, RET
	lw  $ra, 4($sp)
	lw  $s1, 8($sp)
	lw  $s2, 12($sp)
	lw  $s3, 16($sp)
	lw  $s4, 20($sp)
	add $sp, $sp, 24
	jr $ra


RET:
	lw  $ra, 4($sp)
	lw  $s1, 8($sp)
	lw  $s2, 12($sp)
	lw  $s3, 16($sp)
	lw  $s4, 20($sp)
	add $v0, $v0, 1
	add $sp, $sp, 24
	jr $ra



Base_1:
	add $v0, $zero, -1
	lw  $ra, 4($sp)
	lw  $s1, 8($sp)
	lw  $s2, 12($sp)
	lw  $s3, 16($sp)
	lw  $s4, 20($sp)
	add $sp, $sp, 24
	jr $ra


Base_2:
	add $v0, $zero, 0
	lw  $ra, 4($sp)
	lw  $s1, 8($sp)
	lw  $s2, 12($sp)
	lw  $s3, 16($sp)
	lw  $s4, 20($sp)
	add $sp, $sp, 24
	jr $ra

