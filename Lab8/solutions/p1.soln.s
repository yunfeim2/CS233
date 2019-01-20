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
        
	
		blt		$v0, 0, _dfs_ret_two	##	if (ret >= 0)
		
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