section .text
  global strlen

strlen:
  mov rax, -1
  cmp rdi, 0
  je .exit
  mov r12, -1

.loop:
  inc r12
  inc rax
  cmp byte [rdi + r12], 0
  jne .loop

.exit:
  ret
