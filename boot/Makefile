CC=aarch64-linux-gnu-gcc
AS=aarch64-linux-gnu-as
LD=aarch64-linux-gnu-ld
OBJCPY=aarch64-linux-gnu-objcopy

all:
	$(AS) -o ./startup.o startup.S
	$(LD) -o ./startup.elf -T ./linker.ld startup.o
	$(OBJCPY) -O binary ./startup.elf ./kernel_2712.img

clean:
	rm -f ./startup.o ./startup.elf ./kernel_2712.img