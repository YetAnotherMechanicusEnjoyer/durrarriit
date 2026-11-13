section .text
  global putstr
  extern strlen
  extern write

putstr:
  call strlen
  mov r12, rdi
  cmp rax, -1
  je .exit
  mov r13, rax

.write:
  mov rdi, r12
  mov rsi, r13
  call write

.exit:
  ret
