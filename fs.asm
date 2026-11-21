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

read_fs: ; rdi: fd
  push r12
  mov r12, rdi

.loop:
  mov rdi, r12
  mov rax, SYS_READ
  mov rsi, file_buffer
  mov rdx, BUFFER_SIZE
  syscall

  cmp rax, 0x0
  jle .exit

  mov rdx, rax
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, file_buffer
  syscall

  jmp .loop

.exit:
  mov [file_buffer], NEWLINE
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, file_buffer
  mov rdx, 0x1
  syscall

  pop r12
  ret
