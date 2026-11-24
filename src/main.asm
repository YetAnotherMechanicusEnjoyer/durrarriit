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
  err_no_arg db "Error: missing file argument", 0xA, 0x0
  err_open db "Error: opening file", 0xA, 0x0

section .text
  global main

  extern putstr
  extern puterr

  extern args_init
  extern args_get

  extern dynstr_init
  extern dynstr_push_str
  extern dynstr_push_char
  extern dynstr_free

  extern open_fs
  extern close_fs
  extern read_fs

main: ; rdi: argc, rsi: argv, rdx: envp -> exit_code
  push r12
  push r13

  call args_init

  mov rdi, 0x1
  call args_get
  test rax, rax
  jz .error_no_arg
  mov r12, rax

  lea rdi, [rel str_obj]
  call dynstr_init

  lea rdi, [rel str_obj]
  mov rsi, r12
  call dynstr_push_str

  lea rdi, [rel str_obj]
  lea rsi, [rel msg]
  call dynstr_push_str

  lea rdi, [rel str_obj]
  mov sil, NEWLINE
  call dynstr_push_char

  mov rdi, r12
  call open_fs
  cmp rax, 0x0
  jl .error_open
  mov r13, rax

  mov rdi, r13
  lea rsi, [rel str_obj]
  call read_fs

  mov rdi, r13
  call close_fs

  mov rdi, [rel str_obj]
  call putstr

  lea rdi, [rel str_obj]
  call dynstr_free

  xor rax, rax
  jmp .exit

.error_no_arg:
  lea rdi, [rel err_no_arg]
  call puterr
  mov rax, 0x1
  jmp .exit

.error_open:
  lea rdi, [rel str_obj]
  call dynstr_free
  lea rdi, [rel err_open]
  call puterr
  mov rax, 0x2

.exit:
  pop r13
  pop r12
  ret
