.include "labels.asm"

.globl task_1_seg, task_3_seg

.data
contador_1: .word 0
contador_3: .word 0

tabela: .byte 0x3F, 0x06, 0x5B, 0x4F,
            0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F
dez:        .word 10

.eqv display_direito 0xffff0010
.eqv display_esquerdo  0xffff0011

.text
task_1_seg:
    la $t0, contador_1
    lw $t1, 0($t0)

    lw $t2, dez
    divu $t1, $t2
    mfhi $t3

    la $t4, tabela
    add $t3, $t3, $t4
    lb $t5, 0($t3)

    la $t2, display_esquerdo
    sb $t5, 0($t2)

    # Lógica de incremento (com mod 10)
    addi $t1, $t1, 1
    li $t8, 10
    divu $t1, $t8
    mfhi $t1
    sw $t1, 0($t0)
    
    # Atraso de 1000 ms
    li $t6, 1000
    li $v0, 30
    syscall
    add $t7, $a0, $t6
    
delay_loop_1:
    li $v0, 30
    syscall
    blt $a0, $t7, delay_loop_1

    j task_1_seg
    

task_3_seg:
    la $t0, contador_3
    lw $t1, 0($t0)

    lw $t2, dez
    divu $t1, $t2
    mfhi $t3            # mod 10

    la $t4, tabela
    add $t3, $t3, $t4
    lb $t5, 0($t3)

    la $t2, display_direito
    sb $t5, 0($t2)
    
    addi $t1, $t1, 1
    li $t8, 10
    divu $t1, $t8
    mfhi $t1
    sw $t1, 0($t0)

    # Atraso de 3000ms
    li $t6, 3000
    li $v0, 30
    syscall
    add $t7, $a0, $t6

delay_loop_3:
    li $v0, 30
    syscall
    blt $a0, $t7, delay_loop_3

    j task_3_seg
