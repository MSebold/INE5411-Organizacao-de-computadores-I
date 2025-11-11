.data
	.eqv MAX 8
	.eqv tam_bloco 4

	const_um: .float 1.0
	const_dois: .float 2.0

.text

main:
	li $s6, MAX
	li $s7, tam_bloco
    
	mul $t0, $s6, $s6
	mul $a0, $t0, 4
    
	li $v0, 9
	syscall 
	move $s4, $v0
    
	li $v0, 9
	syscall 
	move $s5, $v0
    
	l.s $f10, const_um
	l.s $f11, const_dois
    
	li $t1, 0

loop_init:
	bge $t1, $t0, fim_loop_init
    
	mul $t2, $t1, 4
	add $t3, $s4, $t2
	add $t4, $s5, $t2
	s.s $f10, 0($t3)
	s.s $f11, 0($t4)
	addi $t1, $t1, 1
	j loop_init
fim_loop_init:
	li $s0, 0

loop_i:
	bge $s0, $s6, fim_loop_i
	li $s1, 0
	
loop_j:
	bge $s1, $s6, fim_loop_j
	add $t0, $s0, $s7
	move $s2, $s0
	
loop_ii:
	bge $s2, $t0, fim_loop_ii
	add $t1, $s1, $s7
	move $s3, $s1
	
loop_jj:
	bge $s3, $t1, fim_loop_jj

	# end A[ii,jj]
	mul $t2, $s2, $s6
	add $t2, $t2, $s3
	mul $t2, $t2, 4
	add $t3, $s4, $t2

	# end B[jj,ii]
	mul $t4, $s3, $s6
	add $t4, $t4, $s2
	mul $t4, $t4, 4
	add $t5, $s5, $t4

	# A[ii,jj] = A[ii,jj] + B[jj,ii]
	l.s $f0, 0($t3)
	l.s $f1, 0($t5)
	add.s $f2, $f0, $f1
	s.s $f2, 0($t3)

	addi $s3, $s3, 1
	j loop_jj
fim_loop_jj:
	addi $s2, $s2, 1
	j loop_ii
fim_loop_ii:
	add $s1, $s1, $s7
	j loop_j
fim_loop_j:
	add $s0, $s0, $s7
	j loop_i
fim_loop_i:
	li $v0, 10
	syscall
