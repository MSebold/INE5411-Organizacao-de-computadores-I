.data
	.eqv MAX 8

	const_um: .float 1.0
	const_dois: .float 2.0

.text
main:
	li $s4, MAX

	mul $t0, $s4, $s4
	mul $a0, $t0, 4

	li $v0, 9
	syscall 
	move $s2, $v0

	li $v0, 9
	syscall 
	move $s3, $v0

	l.s $f10, const_um
	l.s $f11, const_dois

	li $t1, 0

loop_init:
	bge $t1, $t0, fim_loop_init

	mul $t2, $t1, 4

	add $t3, $s2, $t2
	add $t4, $s3, $t2

	s.s $f10, 0($t3)
	s.s $f11, 0($t4)

	addi $t1, $t1, 1
	j loop_init

fim_loop_init:
	li $s0, 0
	
loop_i:
	bge $s0, $s4, fim_loop_i
	li $s1, 0

loop_j:
	bge $s1, $s4, fim_loop_j

	# end A[i,j]
	mul $t0, $s0, $s4
	add $t0, $t0, $s1
	mul $t0, $t0, 4
	add $t1, $s2, $t0

	# end B[j,i]
	mul $t2, $s1, $s4
	add $t2, $t2, $s0
	mul $t2, $t2, 4
	add $t3, $s3, $t2

	# A[i,j] = A[i,j] + B[j,i]
	l.s $f0, 0($t1)
	l.s $f1, 0($t3)
	add.s $f2, $f0, $f1
	s.s $f2, 0($t1)

	addi $s1, $s1, 1
	j loop_j
fim_loop_j:
	addi $s0, $s0, 1
	j loop_i
fim_loop_i:
	li $v0, 10
	syscall
    