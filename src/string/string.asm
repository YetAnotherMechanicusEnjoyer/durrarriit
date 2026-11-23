section .text
  global strlen
  global memcpy
  global strdup
  extern alloc

strlen: ; rdi: string -> usize
  mov rax, -0x1
  test rdi, rdi
  je .exit

.loop:
  inc rax
  cmp byte [rdi + rax], 0x0
  jne .loop

.exit:
  ret

memcpy: ; rdi: dest, rsi: src, rdx: n -> dst
  mov rax, rdi
  mov rcx, rdx
  cld
  rep movsb
  ret

strdup: ; rdi: string -> NULL!ptr
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

  mov rdi, rax
  mov rsi, r12
  lea rdx, [r13 + 1]
  call memcpy
  jmp .exit

.error:
  xor eax, eax

.exit:
  pop r13
  pop r12
  ret
