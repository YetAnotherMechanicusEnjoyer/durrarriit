section .text
  global strlen

  global memcpy
  global strdup

  global strcmp
  global strncmp

  extern alloc

strlen: ; rdi: string -> usize
  or rax, -0x1
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

strncmp: ; rdi: s1, rsi: s2, rdx: n -> usize
  xor ecx, ecx

.loop:
  cmp rcx, rdx
  jae .equal
  mov al, [rdi + rcx]
  mov r8b, [rsi + rcx]
  cmp al, r8b
  jne .diff
  test al, al
  jz .equal
  inc rcx
  jmp .loop

.diff:
  movzx eax, al
  movzx r8d, r8b
  sub eax, r8d
  ret

.equal:
  xor eax, eax
  ret

strcmp: ; rdi: s1, rsi: s2 -> usize
.loop:
  mov al, [rdi]
  mov r8b, [rsi]
  cmp al, r8b
  jne .diff
  test al, al
  jz .equal
  inc rdi
  inc rsi
  jmp .loop

.diff:
  movzx eax, al
  movzx r8d, r8b
  sub eax, r8d
  ret

.equal:
  xor eax, eax
  ret
