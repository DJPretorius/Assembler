all: main.o Tree.o
	gcc main.o -g Tree.o -o main.out -m64 -lm -static

main.o: main.c
	gcc -c main.c -g -m64 -std=c99

Tree.o: Tree.asm
	yasm -f elf64 -g dwarf2 Tree.asm -o Tree.o

run: all
	./main.out

clear:
	rm *.o *.out
