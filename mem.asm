section .text
  global alloc
  global free

alloc: ; rdi: usize -> ptr
  mov rsi, rdi
  mov rax, 0x9
  xor rdi, rdi
  mov rdx, 0x3
  mov r10, 0x22
  mov r8, -0x1
  xor r9, r9
  syscall ; sys_mmap
  ret

free: ; rdi: ptr
  mov rax, 0xB
  syscall ; sys_munmap
  ret
