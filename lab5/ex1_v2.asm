.data
	text_1: .asciiz "Digite o limite do contador: "
	text_2: .asciiz "Contador: "
	new_line: .asciiz "\n"
	
.text
main:
	li $v0, 4
	la $a0, text_1
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0          # guarda o limite
	
	li $t0, 0              # contador inicia em 0
	
loop:
	bge $t0, $s0, exit     # fim quando contador >= limite
		
	li $v0, 4
	la $a0, text_2
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	addi $t0, $t0, 2       # incrementa de 2 em 2
	
	j loop
	
exit:
	li $v0, 10             # encerra o programa
	syscall
