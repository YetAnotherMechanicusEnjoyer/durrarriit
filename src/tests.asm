
section .rodata
  test_1 db "hello   world", 0
  sep_1 db " ", 0

  test_2 db "  alpha beta  ", 0
  sep_2 db " ", 0

  test_3 db "red-green_blue", 0
  sep_3 db "-_", 0

  test_4 db "   ", 0
  sep_4 db " ", 0

  test_5 db 0
  sep_5 db " ", 0

  null_msg db "(NULL)", 0xA, 0
  newline db 0xA, 0

section .text
  global tests

  extern slice
  extern strlen
  extern free
  extern putstr

tests:
  lea rdi, [rel test_1]
  lea rsi, [rel sep_1]
  call test_slice

  lea rdi, [rel test_2]
  lea rsi, [rel sep_2]
  call test_slice

  lea rdi, [rel test_3]
  lea rsi, [rel sep_3]
  call test_slice

  lea rdi, [rel test_4]
  lea rsi, [rel sep_4]
  call test_slice

  lea rdi, [rel test_5]
  lea rsi, [rel sep_5]
  call test_slice

  xor eax, eax
  ret

test_slice: ; rdi: string, rsi: separators
  push rbx
  push r12
  push r13
  push r14

  call slice
  test rax, rax
  jz .empty

  mov r12, rax
  xor rbx, rbx

.loop:
  mov rdi, [r12 + rbx * 8]
  test rdi, rdi
  jz .free_array

  call putstr

  lea rdi, [rel newline]
  call putstr

  mov rdi, [r12 + rbx * 8]
  call strlen
  inc rax

  mov r13, rax
  mov rdi, [r12 + rbx * 8]
  mov rsi, r13
  call free

  inc rbx
  jmp .loop

.free_array:
  mov rdi, r12
  lea rsi, [rbx * 8 + 8]
  call free
  jmp .exit

.empty:
  lea rdi, [rel null_msg]
  call putstr

.exit:
  pop r14
  pop r13
  pop r12
  pop rbx
  ret

