all: all-no-clean clean clean-isodir
all-no-clean: bootloader kernel link make-rescue
all-test: all test

clean:
	@echo Deleting temporary files...
	rm -r ./tmp/

clean-isodir:
	@echo Formatting ISO...
	rm -r ./isodir/

bootloader: ./ossrc/boot.s
	@echo Assembling bootloader...
	mkdir -p ./tmp/
	./src/cross/bin/i686-elf-as ./ossrc/boot.s -o ./tmp/boot.o

kernel : ./ossrc/moloukhiya.c
	@echo Compiling moloukhiya...
	mkdir -p ./tmp/
	./src/cross/bin/i686-elf-gcc -c ./ossrc/moloukhiya.c -o ./tmp/moloukhiya.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

link:
	@echo Linking bootloader and moloukhiya...
	./src/cross/bin/i686-elf-gcc -T ./ossrc/linker.ld -o ./tmp/picos.bin -ffreestanding -O2 -nostdlib ./tmp/boot.o ./tmp/moloukhiya.o -lgcc

make-rescue:
	grub-file --is-x86-multiboot ./tmp/picos.bin
	mkdir -p ./isodir/boot/grub/
	cp ./tmp/picos.bin ./isodir/boot/picos.bin
	cp ./ossrc/grub.cfg ./isodir/boot/grub/grub.cfg
	@echo Creating ISO image...
	grub-mkrescue -o ./picos.iso ./isodir/
	@echo Done!

quick-test:
	mkdir -p ./tmp/
	./src/cross/bin/i686-elf-as ./ossrc/boot.s -o ./tmp/boot.o
	./src/cross/bin/i686-elf-gcc -c ./ossrc/moloukhiya.c -o ./tmp/moloukhiya.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	./src/cross/bin/i686-elf-gcc -T ./ossrc/linker.ld -o ./tmp/picos.bin -ffreestanding -O2 -nostdlib ./tmp/boot.o ./tmp/moloukhiya.o -lgcc
	qemu-system-x86_64 -kernel ./tmp/picos.bin

test:
	qemu-system-x86_64 -cdrom ./picos.iso
