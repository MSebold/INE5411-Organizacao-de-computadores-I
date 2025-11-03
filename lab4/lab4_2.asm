.data
	matriz: .word 0:256
.text
main:
	# for (col = 0; col < 16; col++)
	#	for (row = 0; row < 16; row++)
	#		data[row][col] = value++
	
	la	$t4, matriz
	li	$t2, 0	# value = 0
	li	$t0, 0	# col = 0
for1:	
	li	$t1, 0 	# row = 0
for2:
	
	sll	$t3, $t1, 4 	# offset = 16*row
	add	$t3, $t3, $t0 	# offset = 16*row + col
	sll	$t3, $t3, 2	# converte para tamnho de word
	add	$t3, $t4, $t3	# end = end + offset
	sw	$t2, 0($t3)
	addi	$t2, $t2, 1
	
	addi	$t1, $t1, 1
	bne	$t1, 16, for2
end2:
	addi	$t0, $t0, 1
	bne	$t0, 16, for1
end1:

