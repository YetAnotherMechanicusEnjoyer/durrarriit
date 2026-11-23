%define STDOUT 0x1
%define NEWLINE 0xA

%define OFF_ARGC 0x8
%define OFF_ARGV 0x10

%define SYS_EXIT 0x3C

%macro exit 1
  mov rdi, %1
  mov rax, SYS_EXIT
  syscall
%endmacro

section .bss
  str_obj resb 24

section .rodata
  msg db "'s content:", 0x0
  file db ".gitignore", 0x0

section .text
  global main

  extern putstr

  extern dynstr_init
  extern dynstr_push_str
  extern dynstr_push_char
  extern dynstr_free

  extern open_fs
  extern close_fs
  extern read_fs

main:
  lea rdi, [rel str_obj]
  call dynstr_init

  lea rdi, [rel str_obj]
  lea rsi, [rel file]
  call dynstr_push_str

  lea rdi, [rel str_obj]
  lea rsi, [rel msg]
  call dynstr_push_str

  lea rdi, [rel str_obj]
  mov sil, NEWLINE
  call dynstr_push_char

  lea rdi, [rel file]
  call open_fs
  mov r12, rdi
  mov rdi, rax
  lea rsi, [rel str_obj]
  call read_fs
  call close_fs

  mov rdi, [rel str_obj]
  call putstr

  lea rdi, [rel str_obj]
  call dynstr_free

  xor rax, rax
  ret
