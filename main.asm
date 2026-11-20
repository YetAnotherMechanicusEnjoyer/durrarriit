section .rodata
  hello db "Hello,", 0x0
  world db " world!", 0xA, 0x0

section .text
  global _start
  extern strcat
  extern putstr
  extern strdup
  extern free

_start:
  push rbp
  mov rbp, rsp

.copy:
  lea rdi, [rel hello]
  call strdup

.strcat:
  mov rdi, rax
  lea rsi, [rel world]
  call strcat

.putstr:
  mov rdi, rax
  call putstr

.exit:
  pop rbp
  mov rax, 0x3C
  xor rdi, rdi
  syscall ; exit
