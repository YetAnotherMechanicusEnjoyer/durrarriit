section .rodata
  msg db "Hello, world!", 10, 0

section .text
  global _start
  extern putstr

_start:
  push rbp

.putstr:
  lea rdi, [rel msg]
  call putstr

.exit:
  pop rbp

  mov rax, 60
  xor rdi, rdi
  syscall
