section .text
  global putchar
  extern write

putchar: ; rdi: usize -> usize
  push rdi
  mov rdi, rsp
  mov rsi, 0x1
  call write
  pop rdi
  ret
