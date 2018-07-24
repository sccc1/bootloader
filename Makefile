#25  dd if=/dev/zero of=build/disk.img bs=1024 count=720
#26  dd if=build/bootsector.bin of=build/disk.img bs=512 count=1 conv=notrunc

NASM := $(shell which nasm)
DD := $(shell which dd)
MKDIR := $(shell which mkdir)
VPATH := src
.PHONY: clean bin

bin : bootsector.asm
	$(MKDIR) build
	$(NASM)	-f bin $^ -o build/bootsector.bin

clean:
	rm -rf build

all: bin
