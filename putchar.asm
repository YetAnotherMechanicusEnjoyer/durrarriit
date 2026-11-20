section .text
  global putchar
  extern write

putchar: ; rdi: usize -> usize
  mov rsi, 0x1
  call write
  ret
