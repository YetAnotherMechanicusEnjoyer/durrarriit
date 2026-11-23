%define OFF_ARGC 0x8
%define OFF_ARGV 0x10

%define SYS_EXIT 0x3C

%macro exit 1
  mov rdi, %1
  mov rax, SYS_EXIT
  syscall
%endmacro

section .text
  global _start
  extern main

_start:
  xor ebp, ebp
  push rbp
  mov rbp, rsp

  mov rdi, [rbp + OFF_ARGC]
  lea rsi, [rbp + OFF_ARGV]
  lea rdx, [rbp + OFF_ARGV + rdi * 0x8 + 0x8]
  call main

  mov rsp, rbp
  pop rbp
  exit rax
