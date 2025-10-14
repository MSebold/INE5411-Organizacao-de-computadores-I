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
	
	move $a0, $s0
	addi $a0, $a0, 1
	li $t0, 4
	mul $a0, $a0, $t0
	li $v0, 9
	syscall
	move $s1, $v0
	
	li $v0, 4
	la $a0, text_2
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	li $v0, 4
	la $a0, text_3
	syscall
	
	li $t0, 0
	move $t1, $s1
loop_fill:
	bge $t0, $s0, exit_fill
	
	li $v0, 5
	syscall
	sw $v0, 0($t1)
	
	addi $t1, $t1, 4
	addi $t0, $t0, 1
	j loop_fill
	
exit_fill:
	li $v0, 4
	la $a0, text_4
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	sw $s2, 0($t1)
	
	move $t2, $s1
	
search_loop:
	lw $t3, 0($t2)
	
	beq $t3, $s2, exit_search 
	
	addi $t2, $t2, 4
	j search_loop
	
exit_search:
	bne $t2, $t1, found
	
not_found:
	li $v0, 4
	la $a0, text_6
	syscall
	j exit
	
found:
	li $v0, 4
	la $a0, text_5
	syscall
	
exit:
	li $v0, 10
	syscall