section .text
  global putstr
  extern strlen
  extern write

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
