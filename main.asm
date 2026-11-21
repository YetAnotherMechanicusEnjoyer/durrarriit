%define STDOUT 0x1
%define NEWLINE 0xA

%define SYS_EXIT 0x3C

%macro exit 1
  mov rax, SYS_EXIT
  mov rdi, %1
  syscall
%endmacro

section .rodata
  hello db "This is", 0x0
  world db " a very long text!", 0x0
  file db "build.casm", 0x0

section .text
  global _start
  extern strcat
  extern putchar
  extern putstr
  extern strdup
  extern open_fs
  extern close_fs
  extern read_fs
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
  mov rdi, NEWLINE
  call putchar

.fs:
  lea rdi, [rel file]
  call open_fs
  mov r12, rdi
  mov rdi, rax
  call read_fs
  call close_fs

.exit:
  mov rsp, rbp
  pop rbp
  exit 0x0
