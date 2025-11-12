.data
	# Define as constantes MAX (dimensão da matriz = 8) 
	# e o tamanho do bloco para processamento (4x4)
	.eqv MAX 8
	.eqv tamanho_bloco 4

	# Define constantes para inicialização das matrizes
	constante_um: .float 1.0
	constante_dois: .float 2.0

.text

main:
	li 		$s6, MAX
	li 		$s7, tamanho_bloco
    
	mul 	$t0, $s6, $s6
	mul 	$a0, $t0, 4
    
	li 		$v0, 9
	syscall 
	move 	$s4, $v0
    
	li 		$v0, 9
	syscall 
	move 	$s5, $v0
    
	l.s 	$f10, constante_um
	l.s 	$f11, constante_dois
    
	li 		$t1, 0

loop_init:
	bge 	$t1, $t0, end_loop_init
    
	mul 	$t2, $t1, 4
	add 	$t3, $s4, $t2
	add 	$t4, $s5, $t2
	s.s 	$f10, 0($t3)
	s.s 	$f11, 0($t4)
	addi 	$t1, $t1, 1
	j 		loop_init
end_loop_init:
	li 		$s0, 0

# --- Início do Processamento em Blocos --- #
# O código implementa 4 loops aninhados para processar as matrizes em blocos.
# Pseudocódigo (C):
# for (i = 0; i < MAX; i += tamanho_bloco) {
#   for (j = 0; j < MAX; j += tamanho_bloco) {
#     for (ii = i; ii < i + tamanho_bloco; ii++) {
#       for (jj = j; jj < j + tamanho_bloco; jj++) {
#         A[ii][jj] = A[ii][jj] + B[jj][ii]; // Operação principal
#       }
#     }
#   }
# }

loop_i:
	bge 	$s0, $s6, end_loop_i
	li 		$s1, 0
	
loop_j:
	bge 	$s1, $s6, end_loop_j
	add 	$t0, $s0, $s7
	move 	$s2, $s0
	
loop_ii:
	bge 	$s2, $t0, end_loop_ii
	add 	$t1, $s1, $s7
	move 	$s3, $s1
	
loop_jj:
	bge 	$s3, $t1, end_loop_jj

	# --- Núcleo do Cálculo --- #
	# Operação: A[ii][jj] = A[ii][jj] + B[jj][ii]

	# end A[ii,jj] (Cálculo do endereço de A[ii][jj])	mul 	$t2, $s2, $s6
	add 	$t2, $t2, $s3
	mul 	$t2, $t2, 4
	add 	$t3, $s4, $t2

	# end B[jj,ii] (Cálculo do endereço de B[jj][ii] - Acesso à transposta)
	mul 	$t4, $s3, $s6
	add 	$t4, $t4, $s2
	mul 	$t4, $t4, 4
	add 	$t5, $s5, $t4

	# A[ii,jj] = A[ii,jj] + B[jj,ii]
	l.s 	$f0, 0($t3)
	l.s 	$f1, 0($t5)
	add.s 	$f2, $f0, $f1
	s.s 	$f2, 0($t3)

	# --- end do Núcleo --- #

	addi 	$s3, $s3, 1
	j 		loop_jj
end_loop_jj:
	addi 	$s2, $s2, 1
	j 		loop_ii
end_loop_ii:
	add 	$s1, $s1, $s7
	j 		loop_j
end_loop_j:
	add 	$s0, $s0, $s7
	j 		loop_i
end_loop_i:

	# --- end do Programa --- #
	li 		$v0, 10
	syscall
