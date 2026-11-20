%define SYS_MMAP 0x9
%define SYS_MUNMAP 0xB

section .text
  global alloc
  global free

alloc: ; rdi: usize -> ptr
  mov rsi, rdi
  mov rax, SYS_MMAP
  xor rdi, rdi
  mov rdx, 0x3
  mov r10, 0x22
  mov r8, -0x1
  xor r9, r9
  syscall ; sys_mmap
  ret

free: ; rdi: ptr
  mov rax, SYS_MUNMAP
  syscall ; sys_munmap
  ret
