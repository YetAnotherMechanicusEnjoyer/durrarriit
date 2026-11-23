%define STDOUT 0x1
%define O_RDONLY 0x0
%define READ_MOD 0644o
%define BUFFER_SIZE 2048

%define SYS_READ 0x0
%define SYS_WRITE 0x1
%define SYS_OPEN 0x2
%define SYS_CLOSE 0x3

%define NEWLINE 0xA

section .data
  fd dw 0

section .bss
  file_buffer resb BUFFER_SIZE

section .text
  global open_fs
  global close_fs
  global read_fs

  extern putstr
  extern dynstr_push_buf
  extern dynstr_push_char

open_fs: ; rdi: filename
  mov rax, SYS_OPEN
  mov rsi, O_RDONLY
  mov rdx, READ_MOD
  syscall
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
  mov rdi, r13
  mov sil, NEWLINE
  call dynstr_push_char
  mov rdi, r12 ; restore fd

  pop r13
  pop r12
  ret
