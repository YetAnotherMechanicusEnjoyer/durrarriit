section .bss
  ctx_argc resq 1
  ctx_argv resq 1
  ctx_envp resq 1

section .text
  global args_init
  global args_len
  global args_get
  global args_has
  global env_get

  extern strcmp
  extern strncmp

args_init:
  mov [rel ctx_argc], rdi
  mov [rel ctx_argv], rsi
  mov [rel ctx_envp], rdx
  ret

args_len: ; -> usize
  mov rax, [rel ctx_argc]
  ret

args_get: ; rdi: index -> 0!string
  cmp rdi, [rel ctx_argc]
  jge .out_of_bounds

  mov rax, [rel ctx_argv]
  mov rax, [rax + rdi * 0x8]
  ret

.out_of_bounds:
  xor eax, eax
  ret

args_find: ; rdi: string -> 0!index
  push r12
  push r13
  mov r12, rdi
  mov r13, 0x1

.loop:
  mov rdi, r13
  call args_get
  test rax, rax
  jz .not_found

  mov rdi, rax
  mov rsi, r12
  call strcmp
  test rax, rax
  jz .found

  inc r13
  jmp .loop

.found:
  mov rax, r13
  jmp .exit

.not_found:
  xor eax, eax

.exit:
  pop r13
  pop r12
  ret

env_get: ; rdi: "KEY=" -> 0!value
  push r12
  push r13
  push r14

  mov r12, rdi
  mov r13, [rel ctx_envp]

  xor r14, r14
.key_len:
  cmp byte [r12 + r14], 0x0
  je .search_loop
  inc r14
  jmp .key_len

.search_loop:
  mov rdi, [r13]
  test rdi, rdi
  jz .not_found

  mov rsi, r12
  mov rdx, r14
  call strncmp
  test rax, rax
  jz .found

  add r13, 0x8
  jmp .search_loop

.found:
  mov rax, [r13]
  add rax, r14
  jmp .exit

.not_found:
  xor eax, eax

.exit:
  pop r14
  pop r13
  pop r12
  ret
