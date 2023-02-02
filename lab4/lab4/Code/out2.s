.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"
.globl main
.text
read:
  li $v0, 4
  la $a0, _prompt
  syscall
  li $v0, 5
  syscall
  jr $ra

write:
  li $v0, 1
  syscall
  li $v0, 4
  la $a0, _ret
  syscall
  move $v0, $0
  jr $ra

_fact:
  addi $sp, $sp, -4
  sw $fp, 0($sp)
  move $fp, $sp
  addi $sp, $sp, -40
  lw $t0, 8($fp)
  sw $t0, -4($fp)
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -8($fp)
  li $t0, 1
  sw $t0, -12($fp)
  lw $t1, -8($fp)
  lw $t2, -12($fp)
  beq $t1, $t2, label1
  j label2
label1:
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -16($fp)
  lw $v0, -16($fp)
  addi $sp, $fp, 4
  lw $fp, 0($fp)
  jr $ra
  j label3
label2:
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -20($fp)
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -24($fp)
  li $t0, 1
  sw $t0, -28($fp)
  lw $t1, -24($fp)
  lw $t2, -28($fp)
  sub $t0, $t1, $t2
  sw $t0, -32($fp)
  addi $sp, $sp, -4
  lw $t0, -32($fp)
  sw $t0, 0($sp)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal _fact
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  sw $v0, -36($fp)
  addi $sp, $sp, 4
  lw $t1, -20($fp)
  lw $t2, -36($fp)
  mul $t0, $t1, $t2
  sw $t0, -40($fp)
  lw $v0, -40($fp)
  addi $sp, $fp, 4
  lw $fp, 0($fp)
  jr $ra
label3:

main:
  addi $sp, $sp, -4
  sw $fp, 0($sp)
  move $fp, $sp
  addi $sp, $sp, -40
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal read
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  sw $v0, -4($fp)
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -8($fp)
  lw $t1, -8($fp)
  move $t0, $t1
  sw $t0, -12($fp)
  li $t0, 1
  sw $t0, -16($fp)
  lw $t1, -12($fp)
  lw $t2, -16($fp)
  bgt $t1, $t2, label4
  j label5
label4:
  lw $t1, -8($fp)
  move $t0, $t1
  sw $t0, -20($fp)
  addi $sp, $sp, -4
  lw $t0, -20($fp)
  sw $t0, 0($sp)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal _fact
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  sw $v0, -24($fp)
  addi $sp, $sp, 4
  lw $t1, -24($fp)
  move $t0, $t1
  sw $t0, -28($fp)
  j label6
label5:
  li $t0, 1
  sw $t0, -32($fp)
  lw $t1, -32($fp)
  move $t0, $t1
  sw $t0, -28($fp)
label6:
  lw $t1, -28($fp)
  move $t0, $t1
  sw $t0, -36($fp)
  lw $a0, -36($fp)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  li $t0, 0
  sw $t0, -40($fp)
  lw $v0, -40($fp)
  addi $sp, $fp, 4
  lw $fp, 0($fp)
  jr $ra
