%.bin: %.s
	gcc -masm=intel -nostdlib -static $< -o $*.elf 
	objdump -Mintel -d $*.elf
	objcopy --dump-section .text=$@ $*.elf
