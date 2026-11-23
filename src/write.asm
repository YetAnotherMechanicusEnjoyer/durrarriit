section .text
  global write
  global putchar
  global putstr
  extern strlen

%define STDOUT 0x1
%define SYS_WRITE 0x1

write: ; rdi: string, rsi: usize
  mov rdx, rsi
  mov rsi, rdi
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  syscall ; write
  ret

putchar: ; rdi: usize -> usize
  push rdi
  mov rdi, rsp
  mov rsi, 0x1
  call write
  pop rdi
  ret

putstr: ; rdi: string -> usize
  push r12
  push r13

  mov r12, rdi
  call strlen
  cmp rax, -1
  je .exit
  mov r13, rax

.write:
  mov rdi, r12
  mov rsi, r13
  call write

.exit:
  pop r13
  pop r12
  ret
