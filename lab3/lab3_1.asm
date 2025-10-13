.data
    prompt_x:       .asciiz "Digite o numero (x) para calcular a raiz quadrada: "
    prompt_n:       .asciiz "Digite o numero de iteracoes (n, ex: 5 a 20): "
    result_msg:     .asciiz "\n--------- Resultados ---------\n"
    my_result_label:.asciiz "Raiz calculada (Newton, n="
    hw_result_label:.asciiz "Raiz calculada (Hardware sqrt.d): "
    error_label:    .asciiz "Erro absoluto: "
    colon:          .asciiz "): "
    newline:        .asciiz "\n"
    one_d:          .double 1.0
    two_d:          .double 2.0
    zero_d:         .double 0.0

.text
.globl main
main:
    # Solicita e lê o número 'x' e as iterações 'n'
    li      $v0, 4
    la      $a0, prompt_x
    syscall
    li      $v0, 7
    syscall

    li      $v0, 4
    la      $a0, prompt_n
    syscall
    li      $v0, 5
    syscall

    # Prepara argumentos e chama o procedimento da raiz
    mov.d   $f12, $f0
    move    $a1, $v0
    jal     raiz_quadrada

    # Salva o resultado do procedimento
    mov.d   $f20, $f12

    # Calcula a raiz usando o hardware para comparação
    sqrt.d  $f22, $f0

    # Calcula o erro absoluto
    sub.d   $f24, $f20, $f22
    ldc1    $f26, zero_d
    c.lt.d  $f24, $f26
    bc1t    is_negative
    j       print_results
is_negative:
    neg.d   $f24, $f24

print_results:
    # Imprime todos os resultados
    li      $v0, 4
    la      $a0, result_msg
    syscall

    li      $v0, 4
    la      $a0, my_result_label
    syscall
    li      $v0, 1
    move    $a0, $a1
    syscall
    li      $v0, 4
    la      $a0, colon
    syscall
    li      $v0, 3
    mov.d   $f12, $f20
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

    li      $v0, 4
    la      $a0, hw_result_label
    syscall
    li      $v0, 3
    mov.d   $f12, $f22
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

    li      $v0, 4
    la      $a0, error_label
    syscall
    li      $v0, 3
    mov.d   $f12, $f24
    syscall
    li      $v0, 4
    la      $a0, newline
    syscall

    # Finaliza o programa
    li      $v0, 10
    syscall

# --------------------------------------------------
# Argumentos:
#   $f12: O número 'x' (double)
#   $a1: O número de iterações 'n' (int)
# Retorno:
#   $f12: A raiz quadrada aproximada de 'x' (double)
# --------------------------------------------------
raiz_quadrada:
    ldc1    $f8, one_d          # Usa $f8 para a estimativa, preservando $f0
    ldc1    $f6, two_d
    mov.d   $f2, $f12
    
    li      $t1, 0
loop:
    # Aplica a fórmula de Newton: Estimativa = ((x / Estimativa) + Estimativa) / 2
    div.d   $f4, $f2, $f8
    add.d   $f4, $f4, $f8
    div.d   $f8, $f4, $f6

    addi    $t1, $t1, 1
    blt     $t1, $a1, loop

    mov.d   $f12, $f8
    jr      $ra
