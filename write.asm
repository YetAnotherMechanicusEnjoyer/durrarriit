section .text
  global write

write:
  mov r12, rdi
  mov r13, rsi

  mov rax, 1
  mov rdi, 1
  mov rsi, r12
  mov rdx, r13
  syscall
  ret
