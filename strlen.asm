section .text
  global strlen

strlen: ; rdi: string -> usize
  mov rax, -0x1
  test rdi, rdi
  je .exit

.loop:
  inc rax
  cmp byte [rdi + rax], 0x0
  jne .loop

.exit:
  ret
