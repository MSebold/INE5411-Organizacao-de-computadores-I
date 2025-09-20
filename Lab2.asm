.data
	var_a: .asciiz "Qual o nome do aquivo .txt que deseja salvar: "
	name: .space 15 # Aloca 15 bytes para o nome do .txt
matriz_a:
	.word 1,2,3,0,1,4,0,0,1
matriz_b:
	.word 1,-2,5,0,1,-4,0,0,1
matriz_c:
	.word 0,0,0,0,0,0,0,0,0

.text

main:
	la	$s0, matriz_a
	la	$s1, matriz_b
	la	$s2, matriz_c

	# Chama PROC_MUL
	la	$a0, matriz_b
	la	$a1, matriz_a
	la	$a2, matriz_c	
	jal	PROC_MUL
	
	# Chama PROC_NOME
	jal	PROC_NOME
	
	j exit
PROC_MUL:

	# Chama a função de transposição	
	# Faz o push da pilha
	# ===================
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	# ===================
	jal 	PROC_TRANS
	
	# Faz o pop da pilha
	# ===================
	lw	$ra, 0($sp)
	# ===================
	
	
	# Inverte a ordem das matrizes em $a0/$a1
	la	$t0, ($a0)
	la	$a0, ($a1)
	la	$a1, ($t0)

	# for i in range(3):
	#     for j in range(3):
	#	  for n in range(3):
	#	      ind_a = 3i+n
	#	      ind_b = 3n+j
	#	      ind_c = 3i+j
	#	      temp = a[ind_a] * b[ind_b]
	#	      temp = temp + c[ind_c]
	#	      c[ind_c] = temp

	# ===============================
	# Dentro do loop i
	li	$t0, 0 	# Inicializa i = 0
salto_i:
	# =========================
	# Dentro do loop j
	li	$t1, 0  # Inicializa j = 0
salto_j:
	# ================
	# Dentro do loop n
	li	$t2, 0  # Inicializa n = 0
salto_n:
	# calcula ind_a
	addi	$t3, $t0, 0	# $t3 = ind_a = i
	li	$t7, 3		# $t7 = 3
	mul	$t3, $t3, $t7	# $t3 = ind_a = 3i
	add	$t3, $t3, $t2	# $t3 = ind_a = 3i+n
	
	# calcula ind_b
	addi	$t4, $t2, 0	# $t4 = ind_b = n
	mul	$t4, $t4, $t7	# $t4 = ind_b = 3n
	add	$t4, $t4, $t1	# $t4 = ind_b = 3n+j
	
	# calcula ind_c
	addi	$t5, $t0, 0	# $t5 = ind_c = i
	mul	$t5, $t5, $t7	# $t5 = ind_c = 3i
	add	$t5, $t5, $t1	# $t5 = ind_c = 3i+j
	
	# carrega a[3i+n] para $t3
	la	$t6, matriz_a	# $t6 = endereço de matriz_a
	li	$t7, 4
	mul	$t3, $t3, 4
	add	$t3, $t6, $t3 	# $t3 = endereco de a[3i+j]
	lw	$t3, 0($t3)	# $t3 = a[3i+j]
	
	# carrega b[3n+j] para $t4
	la	$t6, matriz_b	# $t6 = endereço de matriz_b
	mul	$t4, $t4, 4
	add	$t4, $t6, $t4 	# $t4 = endereco de b[3n+j]
	lw	$t4, 0($t4)	# $t4 = b[3n+j]
	
	# carrega endereco de c[3i+j] para $t5
	la	$t6, matriz_c	# $t6 = endereço de matriz_c
	mul	$t5, $t5, 4
	add	$t5, $t6, $t5 	# $t5 = endereco de c[3i+j]
	
	# armazena $t3 = temp = a[3i+n] * b[3n+j
	mul	$t3, $t3, $t4
	
	# carrega $t4 = c[3i+j]
	lw	$t4, ($t5)
	
	# Realiza temp = temp + c[3i+j]
	add	$t3, $t3, $t4  
	
	# faz (finalmente) c[3i+j] = temp
	sw	$t3, ($t5)
	
	addi	$t2, $t2, 1
	bne	$t2, 3, salto_n
fim_loop_n:
	# ================
	addi	$t1, $t1, 1
	bne	$t1, 3, salto_j
fim_loop_j:
	# =========================
	addi	$t0, $t0, 1
	bne	$t0, 3, salto_i
	# ===============================
fim_loop_i:
	jr	$ra
	
PROC_TRANS:
	la 	$t0, ($a0)
	addi 	$t1, $t0, 4
	addi 	$t2, $t0, 12
	lw 	$t1, 0($t1)
	lw 	$t2, 0($t2)
	sw 	$t2, 4($a0)
	sw 	$t1, 12($a0)
	la 	$t0, ($a0)
	addi 	$t1, $t0, 8
	addi 	$t2, $t0, 24
	lw 	$t1, 0($t1)
	lw 	$t2, 0($t2)
	sw 	$t2, 8($a0)
	sw 	$t1, 24($a0)
	la 	$t0, ($a0)
	addi 	$t1, $t0, 20
	addi 	$t2, $t0, 28
	lw 	$t1, 0($t1)
	lw 	$t2, 0($t2)
	sw 	$t2, 20($a0)
	sw 	$t1, 28($a0)

	jr	$ra

PROC_NOME:
	# Ler os valores dados pelo usuario
	# Ler o nome do .txt (salvo em name)
    	li 	$v0, 4           	
    	la 	$a0, var_a   	
    	syscall
    	
    	li 	$v0, 8
    	la 	$a0, name
    	li	$a1, 15
    	syscall
    	
    	jr	$ra
exit:
	li	$v0, 10
	syscall