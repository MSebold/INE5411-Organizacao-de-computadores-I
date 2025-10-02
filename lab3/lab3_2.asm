.data
    prompt_x:       .asciiz "Digite o valor de x (em radianos): "
    intermediate_msg: .asciiz "Soma apos termo "
    colon_space:    .asciiz ": "
    newline:        .asciiz "\n"
    neg_one_d:      .double -1.0
    zero_d:         .double 0.0

.text

main:
    li      $v0, 4
    la      $a0, prompt_x
    syscall

    li      $v0, 7
    syscall

    ldc1    $f12, zero_d
    mov.d   $f14, $f0
    jal     calcular
    j	    exit

calcular:
    # Pré-calcular -x^2
    mul.d   $f16, $f0, $f0
    ldc1    $f28, neg_one_d
    mul.d   $f16, $f16, $f28

    # Estabelecendo precisao
    li      $t0, 0
    li      $t2, 20

loop_start:
    bge     $t0, $t2, exit_main

    add.d   $f12, $f12, $f14    # sum = sum + term

    # Mostra a convergência (resultado intermediário)
    li      $v0, 4
    la      $a0, intermediate_msg
    syscall
    li      $v0, 1
    addiu   $a0, $t0, 1
    syscall

    li      $v0, 4
    la      $a0, colon_space
    syscall
    li      $v0, 3
    syscall
    
    li      $v0, 4
    la      $a0, newline
    syscall
    # Fim da demonstração da convergência

    addiu   $t0, $t0, 1

    sll     $t4, $t0, 1         
    addiu   $t5, $t4, 1
    mul     $t6, $t4, $t5

    # Converte inteiro para double
    mtc1    $t6, $f20
    cvt.d.w $f20, $f20

    div.d   $f22, $f16, $f20
    mul.d   $f14, $f14, $f22
    
    j       loop_start
    
exit_main:
	jr  $ra

exit:
    li      $v0, 10
    syscall
