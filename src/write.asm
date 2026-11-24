section .text
  global write
  global putchar
  global putstr
  global puterr
  extern strlen

%define STDOUT 0x1
%define STDERR 0x2
%define SYS_WRITE 0x1

write: ; rdi: string, rsi: usize, rdx: fd
  mov r10, rdx
  mov rdx, rsi
  mov rsi, rdi
  mov rax, SYS_WRITE
  mov rdi, r10
  syscall ; write
  ret

putchar: ; rdi: usize
  push rdi
  mov rdi, rsp
  mov rsi, 0x1
  mov rdx, STDOUT
  call write
  pop rdi
  ret

putstr: ; rdi: string -> -1!0
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
  mov rdx, STDOUT
  call write

.exit:
  pop r13
  pop r12
  xor rax, rax
  ret

puterr: ; rdi: string -> -1!0
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
  mov rdx, STDERR
  call write

.exit:
  pop r13
  pop r12
  xor rax, rax
  ret
