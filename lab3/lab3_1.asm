.text
main:
	li	$v0, 5
	syscall
	move	$a0, $v0
	
	jal	square_root
	
	li	$v0, 3
	syscall
	
	li	$v0, 10
	syscall	
square_root:

	li	$t0, 1
	mtc1.d	$t0, $f0	# Guess
	cvt.d.w $f0, $f0
	mtc1.d	$a0, $f2	# x
	cvt.d.w $f2, $f2
	li	$t0, 2
	mtc1.d	$t0, $f6	# 2
	cvt.d.w $f6, $f6
	li	$t1, 0		# i
loop:
	div.d	$f4, $f2, $f0
	add.d	$f4, $f4, $f0
	div.d	$f4, $f4, $f6
	mov.d	$f0, $f4
	
	addi	$t1, $t1, 1
	bne	$t1, 20, loop
	
	mov.d	$f12, $f0
	jr	$ra
end:
