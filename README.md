# picOS
My second operating system, now using arch linux and ditching windows.

picOS is a portmanteau of pico \[describing the intended size of the kernel\] and OS.

## Building

using arch linux, execute `./dependencies.sh` to install all the required packages, then `./install.sh` to compile GCC, then use `make` to compile the OS.
```bash
$ make              # same as make all.
$ make all          # compiles the entire OS, then cleans the tmp folder and iso folder.
$ make all-no-clean # compiles the entire OS, but keeps the tmp folder and iso folder.
$ make all-test     # does make all, then opens the ISO image in qemu.
$ make quick-test   # compiles the entire OS without making the final ISO, then opens the multiboot ELF in qemu.
$ make test         # opens the ISO in qemu.
$ make clean        # gets rid of the tmp folder.
$ make clean-isodir # gets rid of the iso folder.
$ make bootloader   # assembles bootloader into the tmp folder.
$ make kernel       # compiles molokhiya into the tmp folder.
$ make link         # links the bootloader with moloukhiya.
$ make make-rescue  # creates the ISO image with grub-mkrescue.
```
