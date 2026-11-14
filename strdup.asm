section .text
  global strdup
  extern alloc
  extern strlen

strdup:
  push r12
  push r13

  mov r13, rsi
  call alloc
  test rax, rax
  js .error
  mov r12, rax

  mov rdi, r13
  call strlen
  cmp rax, -0x1
  je .error

.copy:
  mov rdi, r12
  mov rsi, r13
  lea rcx, [rax + 1]
  cld
  rep movsb

  mov rax, r12
  jmp .exit

.error:
  xor eax, eax

.exit:
  pop r13
  pop r12
  ret

