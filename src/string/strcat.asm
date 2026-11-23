section .text
  global strcat
  extern strlen

strcat: ; rdi: string, rsi: string -> string
  push r12
  push r13
  push r14

  mov r12, rdi
  mov r14, rsi

  call strlen
  cmp rax, -0x1
  je .error
  mov r13, rax

  mov rdi, r14
  call strlen
  cmp rax, -0x1
  je .error

  lea rdi, [r12 + r13]
  mov rsi, r14
  lea rcx, [rax + 1]
  cld
  rep movsb

  mov rax, r12
  jmp .exit

.error:
  mov rax, -0x1

.exit:
  pop r14
  pop r13
  pop r12
  ret
