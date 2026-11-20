section .text
  global write

%define STDOUT 0x1
%define SYS_WRITE 0x1

write: ; rdi: string, rsi: usize
  mov rdx, rsi
  mov rsi, rdi
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  syscall ; write
  ret
