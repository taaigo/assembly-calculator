target:
	nasm -f elf32 main.asm -o main.o
	ld -m elf_i386 main.o -o main

debug:
	nasm -f elf32 main.asm -o main.o -g
	ld -m elf_i386 main.o -o main -g