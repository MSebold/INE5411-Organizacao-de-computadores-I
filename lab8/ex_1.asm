.data
	# Define as constantes MAX (dimensão da matriz = 8) 
	.eqv MAX 8

	constante_um: .float 1.0
	constante_dois: .float 2.0

.text
main:
	li 		$s4, MAX

	mul 	$t0, $s4, $s4
	mul 	$a0, $t0, 4

	li 		$v0, 9
	syscall 
	move 	$s2, $v0

	li 		$v0, 9
	syscall 
	move 	$s3, $v0

	l.s 	$f10, constante_um
	l.s 	$f11, constante_dois

	li 		$t1, 0

	# --- Loop de Inicialização das Matrizes --- #
	# Percorre todos os 64 elementos, definindo A[i] = 1.0 e B[i] = 2.0
loop_init:
	bge 	$t1, $t0, end_loop_init

	mul 	$t2, $t1, 4

	add 	$t3, $s2, $t2
	add 	$t4, $s3, $t2

	s.s 	$f10, 0($t3)
	s.s 	$f11, 0($t4)

	addi 	$t1, $t1, 1
	j 		loop_init

end_loop_init:
	
	# --- Início do Processamento Principal --- #
	# Implementa o pseudocódigo:
	# for (i = 0; i < MAX; i++) {
	#   for (j = 0; j < MAX; j++) {
	#     A[i][j] = A[i][j] + B[j][i];
	#   }
	# }
	
	li 		$s0, 0
loop_i:
	bge 	$s0, $s4, end_loop_i
	li 		$s1, 0

loop_j:
	bge 	$s1, $s4, end_loop_j

	# --- Cálculo do Endereço de A[i][j] --- #
	mul 	$t0, $s0, $s4
	add 	$t0, $t0, $s1
	mul 	$t0, $t0, 4
	add 	$t1, $s2, $t0

	# --- Cálculo do Endereço de B[j][i] (Transposta) --- #
	mul 	$t2, $s1, $s4
	add 	$t2, $t2, $s0
	mul 	$t2, $t2, 4
	add 	$t3, $s3, $t2

	# --- Operação: A[i,j] = A[i,j] + B[j,i] --- #
	l.s 	$f0, 0($t1)
	l.s 	$f1, 0($t3)
	add.s 	$f2, $f0, $f1
	s.s 	$f2, 0($t1)

	addi 	$s1, $s1, 1
	j 		loop_j
end_loop_j:
	addi 	$s0, $s0, 1
	j 		loop_i
end_loop_i:

	# --- Fim do Programa --- #
	li 		$v0, 10
	syscall
    