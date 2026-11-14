section .text
  global write

write:
  mov rdx, rsi
  mov rsi, rdi
  mov rax, 0x1
  mov rdi, 0x1
  syscall ; write
  ret
