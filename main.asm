section .rodata
  hello db "This is", 0x0
  world db " a very long text!", 0x0

section .text
  global _start
  extern strcat
  extern putchar
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
  push 0xA
  mov rdi, rsp
  call putchar

.exit:
  mov rsp, rbp
  pop rbp
  mov rax, 0x3C
  xor rdi, rdi
  syscall ; exit
