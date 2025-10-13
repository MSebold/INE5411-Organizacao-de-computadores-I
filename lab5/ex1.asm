.data
	text_1: .asciiz "Digite o limite do contador: "
	text_2: .asciiz "Contador: "
	new_line: .asciiz  "\n"
	
.text
main:
	li $v0, 4
	la $a0, text_1
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0 # store limit in $s0
	
	li $t0, 0 # initialize the counter
	
loop:
	bge $t0, $s0, exit
	andi $t1, $t0, 1
	beqz $t1, is_odd
	
	addi $t0, $t0, 1
	
	j loop

is_odd:
	li $v0, 4
	la $a0, text_2
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, new_line
	syscall
	
	addi $t0, $t0, 1
	
	j loop
	
exit:
	li $v0, 10
	syscall
	
	
