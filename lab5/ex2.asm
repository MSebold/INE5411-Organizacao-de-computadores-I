.data
	text_1: .asciiz "Digite o tamanho do vetor: "
	text_2: .asciiz "Digite "
	text_3: .asciiz " números para o vetor:\n"
	text_4: .asciiz "Digite o número a procurar: "
	text_5: .asciiz "Número encontrado!\n"
	text_6: .asciiz "Número não encontrado.\n"
	
.text
main:
	li $v0, 4
	la $a0, text_1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $t0, 4
	mul $a0, $s0, $t0
	li $v0, 9
	syscall
	move $s1, $v0
	move $s7, $v0
	
	li $v0, 4
	la $a0, text_2
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, text_3
	syscall
	
	li $t1, 0
loop_fill:
	bge $t1, $s0, exit_fill
	
	li $v0, 5
	syscall
	sw $v0, 0($s1)
	
	addi $s1, $s1, 4
	addi $t1, $t1, 1
	
	j loop_fill
	
exit_fill:
	move $s2, $s0

	li $v0, 4
	la $a0, text_4
	syscall
	
	li $v0, 5
	syscall
	
	move $s2, $v0
	
	li $t0, 0 # found = 0
	
	li 	$t1, 0
	
	
loop_search: # it is necessary to finish this procedure
	addi	$t2, $s7, 0
	mul	$t3, $t1, 4
	add	$t2, $s7, $t3
	lw	$t2, 0($t2)
	
	bne	$t2, $s2, end_if
	li	$t0, 1
	j 	exit_search
end_if:
	addi	$t1, $t1, 1
	beq 	$t1, $s0, exit_search
	j loop_search
	
exit_search:
	beqz $t0, not_found
	j found
	
not_found:
	li $v0, 4
	la $a0, text_6
	syscall
	
	j exit
	
found:
	li $v0, 4
	la $a0, text_5
	syscall
	
	j exit
	
exit:
	li $v0, 10
	syscall
