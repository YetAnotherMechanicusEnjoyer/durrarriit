%define DYNSTR_INIT_CAP 0x1000 ; 4 KiB

%define OFF_PTR 0x0
%define OFF_LEN 0x8
%define OFF_CAP 0x10

section .text
  global dynstr_init
  global dynstr_reserve
  global dynstr_push_buf
  global dynstr_push_str
  global dynstr_push_char
  global dynstr_free

  extern alloc
  extern realloc
  extern free
  extern strlen
  extern memcpy

dynstr_init: ; rdi: ptr -> -1!0
  push r12
  mov r12, rdi

  mov rdi, DYNSTR_INIT_CAP
  call alloc
  test rax, rax
  js .error

  mov [r12 + OFF_PTR], rax
  mov qword [r12 + OFF_LEN], 0x0
  mov qword [r12 + OFF_CAP], DYNSTR_INIT_CAP
  mov byte [rax], 0x0
  xor eax, eax
  jmp .exit

.error:
  mov rax, -0x1

.exit:
  pop r12
  ret

dynstr_reserve: ; rdi: ptr, rsi: extra_bytes -> -1!0
  push r12
  push r13

  mov r12, rdi
  mov rax, [r12 + OFF_LEN]
  add rax, rsi
  inc rax

  mov r13, [r12 + OFF_CAP]
  cmp rax, r13
  jle .ok

.grow_loop:
  shl r13, 0x1
  cmp rax, r13
  ja .grow_loop

  mov rdi, [r12 + OFF_PTR]
  mov rsi, [r12 + OFF_CAP]
  mov rdx, r13
  call realloc
  test rax, rax
  js .error

  mov [r12 + OFF_PTR], rax
  mov [r12 + OFF_CAP], r13

.ok:
  xor eax, eax
  jmp .exit

.error:
  mov rax, -0x1

.exit:
  pop r13
  pop r12
  ret

dynstr_push_buf: ; rdi: ptr, rsi: buf, rdx: count -> -1!0
  push r12
  push r13
  push r14

  mov r12, rdi
  mov r13, rsi
  mov r14, rdx

  test r14, r14
  jz .ok

  mov rdi, r12
  mov rsi, r14
  call dynstr_reserve
  test rax, rax
  js .error

  mov rdi, [r12 + OFF_PTR]
  add rdi, [r12 + OFF_LEN]
  mov rsi, r13
  mov rdx, r14
  call memcpy

  add [r12 + OFF_LEN], r14
  mov rdi, [r12 + OFF_PTR]
  mov rax, [r12 + OFF_LEN]
  mov byte [rdi + rax], 0x0

.ok:
  xor eax, eax
  jmp .exit

.error:
  mov rax, -0x1

.exit:
  pop r14
  pop r13
  pop r12
  ret

dynstr_push_str: ; rdi: ptr, rsi: string -> -1!0
  push r12
  push r13

  mov r12, rdi
  mov r13, rsi

  mov rdi, r13
  call strlen
  cmp rax, -0x1
  je .error

  mov rdi, r12
  mov rsi, r13
  mov rdx, rax
  call dynstr_push_buf
  jmp .exit

.error:
  mov rax, -0x1

.exit:
  pop r13
  pop r12
  ret

dynstr_push_char: ; rdi: ptr, sil: char -> -1!0
  sub rsp, 0x8
  mov [rsp], sil
  mov rsi, rsp
  mov rdx, 0x1
  call dynstr_push_buf
  add rsp, 0x8
  ret

dynstr_free:
  push r12
  mov r12, rdi

  mov rdi, [r12 + OFF_PTR]
  test rdi, rdi
  jz .exit

  mov rsi, [r12 + OFF_CAP]
  call free

  mov qword [r12 + OFF_PTR], 0x0
  mov qword [r12 + OFF_LEN], 0x0
  mov qword [r12 + OFF_CAP], 0x0

.exit:
  pop r12
  ret
