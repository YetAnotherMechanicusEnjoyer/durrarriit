section .text
  global strdup
  extern alloc
  extern strlen

strdup: ; rdi: string
  push r12
  push r13

  mov r12, rdi
  call strlen
  cmp rax, -0x1
  je .error
  mov r13, rax

  lea rdi, [rax + 1]
  call alloc
  test rax, rax
  js .error

.copy:
  mov rdi, rax
  mov rsi, r12
  lea rcx, [r13 + 1]
  cld
  rep movsb

  jmp .exit

.error:
  xor eax, eax

.exit:
  pop r13
  pop r12
  ret
