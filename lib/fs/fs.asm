%define STDOUT 0x1
%define O_RDONLY 0x0
%define READ_MOD 0644o
%define BUFFER_SIZE 2048
%define AT_FDCWD -100

%define SYS_READ 0x0
%define SYS_WRITE 0x1
%define SYS_OPEN 0x2
%define SYS_CLOSE 0x3
%define SYS_OPENAT 0x101

%define NEWLINE 0xA

section .data
  fd dw 0

section .bss
  file_buffer resb BUFFER_SIZE

section .text
  global open_fs
  global create_fs
  global close_fs
  global read_fs

  extern putstr
  extern dynstr_push_buf
  extern dynstr_push_char

open_fs: ; rdi: filename -> fd
  mov rax, SYS_OPEN
  mov rsi, O_RDONLY
  mov rdx, READ_MOD
  syscall
  ret

%define O_WRONLY 01o
%define O_CREAT 0100o
%define O_TRUNC 01000o

create_fs: ; rdi: filename -> fd
  push r12
  mov r12, rdi

  mov rax, SYS_OPENAT
  mov rdi, AT_FDCWD
  mov rsi, r12
  mov rdx, O_WRONLY
  or rdx, O_CREAT
  or rdx, O_TRUNC
  mov r10, READ_MOD
  syscall

  pop r12
  ret

close_fs: ; rdi: fd
  mov rax, SYS_CLOSE
  syscall
  ret

read_fs: ; rdi: fd, rsi: string
  push r12
  push r13
  mov r12, rdi
  mov r13, rsi

.loop:
  mov rdi, r12
  mov rax, SYS_READ
  mov rsi, file_buffer
  mov rdx, BUFFER_SIZE
  syscall

  cmp rax, 0x0
  jle .exit

  mov rdi, r13
  mov rsi, file_buffer
  mov rdx, rax
  call dynstr_push_buf

  jmp .loop

.exit:
  mov rdi, r12 ; restore fd
  pop r13
  pop r12
  ret
