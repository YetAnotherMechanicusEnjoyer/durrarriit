section .text
  global slice

  extern strlen
  extern strdup
  extern strncmp

  extern alloc
  extern free

is_separator: ; dil: char, rsi: separators -> bool
  xor rax, rax
  or rcx, -0x1

.loop:
  inc rcx

  mov dl, byte [rsi + rcx]
  test dl, dl
  jz .exit

  cmp dil, dl
  je .found

  jmp .loop

.found:
  inc al

.exit:
  ret

handle_separators: ; rdi: string, rsi: separators -> string
  push r12
  push r13
  push r14
  push rbx

  test rdi, rdi
  jz .error
  test rsi, rsi
  jz .error

  mov r12, rdi
  mov r13, rsi

  call strlen

  inc rax
  mov rdi, rax
  call alloc
  test rax, rax
  js .error

  mov rbx, rax
  or r14, -0x1

.loop:
  inc r14

  mov al, byte [r12 + r14]
  test al, al
  jz .exit_normal

  movzx edi, al
  mov rsi, r13
  call is_separator
  test al, al
  jz .push_char

.push_null:
  mov byte [rbx + r14], 0x0
  jmp .loop

.push_char:
  mov al, byte [r12 + r14]
  mov byte [rbx + r14], al
  jmp .loop

.exit_normal:
  mov byte [rbx + r14], 0x0
  mov rax, rbx
  jmp .exit

.error:
  xor rax, rax

.exit:
  pop rbx
  pop r14
  pop r13
  pop r12
  ret

count_words: ; rdi: string, rsi: len -> n
  push r12
  push r13
  push r14

  xor r14, r14
  test rdi, rdi
  jz .exit

  test rsi, rsi
  je .exit

  mov r12, rdi
  mov r13, rsi
  dec r13
  or rcx, -0x1

.loop:
  inc rcx
  cmp r13, rcx
  jb .exit

  mov al, byte [r12 + rcx]
  test al, al
  jnz .found
  jmp .loop

.found:
  inc r14
.skip:
  cmp r13, rcx
  jbe .exit

  inc rcx
  mov al, byte [r12 + rcx]
  test al, al
  jnz .skip
  jmp .loop

.exit:
  mov rax, r14
  pop r14
  pop r13
  pop r12
  ret

slice: ; rdi: string, rsi: separators -> array
  push rbx
  push r12
  push r13
  push r14
  push r15

  test rdi, rdi
  jz .exit
  test rsi, rsi
  jz .exit

  xor rbx, rbx
  mov r12, rdi ; original string
  mov r13, rsi ; separators
  xor r14, r14 ; len
  xor r15, r15

  mov rdi, r12
  call strlen
  mov r14, rax

  mov rdi, r12
  mov rsi, r13
  xor r12, r12 ; array index
  call handle_separators
  test rax, rax
  jz .error
  mov rbx, rax

  mov rdi, rbx
  mov rsi, r14
  call count_words
  test rax, rax
  jz .empty

  lea rdi, [rax * 0x8 + 0x8]
  call alloc
  test rax, rax
  js .error

  mov r15, rax ; final array
  or r13, -0x1 ; index

.loop:
  inc r13
  cmp r14, r13
  jbe .return

  mov al, byte [rbx + r13]
  test al, al
  jz .loop

  lea rdi, [rbx + r13]
  call strdup
  test rax, rax
  jz .error

  mov [r15 + r12 * 0x8], rax
  inc r12

.skip:
  inc r13
  cmp r14, r13
  jbe .return

  cmp byte [rbx + r13], 0x0
  jne .skip
  jmp .loop

.return:
  mov qword [r15 + r12 * 0x8], 0x0
  jmp .free_sep_success

.empty:
  xor rax, rax
  jmp .free_sep

.error:
  xor rax, rax
  test r15, r15
  jz .free_sep

  xor r13, r13

.free_words:
  cmp r13, r12
  jae .free_array

  mov rdi, [r15 + r13 * 0x8]
  call strlen
  inc rax

  mov rdi, [r15 + r13 * 0x8]
  mov rsi, rax
  call free

  inc r13
  jmp .free_words

.free_array:
  mov rdi, r15
  lea rsi, [r12 * 0x8 + 0x8]
  call free

.free_sep:
  test rbx, rbx
  jz .exit

  mov rdi, rbx
  lea rsi, [r14 + 0x1]
  call free
  jmp .exit

.free_sep_success:
  mov rdi, rbx
  lea rsi, [r14 + 0x1]
  call free

  mov rax, r15

.exit:
  pop r15
  pop r14
  pop r13
  pop r12
  pop rbx
  ret
