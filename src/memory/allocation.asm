%define SYS_MMAP 0x9
%define SYS_MUNMAP 0xB
%define SYS_MREMAP 0x19

%define PROT_READ 0x1
%define PROT_WRITE 0x2

%define MAP_PRIVATE 0x02
%define MAP_ANONYMOUS 0x20
%define MREMAP_MAYMOVE 0x1

section .text
  global alloc
  global realloc
  global free

alloc: ; rdi: usize -> ptr
  mov rsi, rdi
  mov rax, SYS_MMAP
  xor rdi, rdi
  mov rdx, PROT_READ
  or rdx, PROT_WRITE
  mov r10, MAP_PRIVATE
  or r10, MAP_ANONYMOUS
  mov r8, -0x1
  xor r9, r9
  syscall ; sys_mmap
  ret

realloc: ; rdi: ptr, rsi: old_size, rdx: new_size -> ptr
  mov rax, SYS_MREMAP
  mov r10, MREMAP_MAYMOVE
  syscall
  ret

free: ; rdi: ptr
  mov rax, SYS_MUNMAP
  syscall ; sys_munmap
  ret
