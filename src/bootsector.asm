bits 16                     ;           16-bit Real Mode
org 0x7c00                  ;           offset 0x7c00 is where BIOS will load us. inform NASM accordingly

boot:
    xor ax, ax              ;           We want a segment of 0 for DS
    mov ds, ax              ;           Set AX to appropriate segment value, that is 0
    mov es, ax              ;           We default to ES=DS
    mov bx, 0x8000          ;           Stack segment can be any usable memory
    mov ss,bx               ;           This places it with the top of the stack @ 0x80000.
    mov sp,ax               ;           Set SP=0 so the bottom of stack will be @ 0x8FFFF

    mov si, stage1Welcome   ;           store welcome string into SI reg
    mov ah, 0x0e            ;           0x0e into ah indicates tty character mode, refer http://www.ctyme.com/intr/rb-0106.htm

.startLoop:
    lodsb                   ;           Load 1 byte from SI into AL
    or al, al               ;           check if AL is 0
    jz halt                 ;           Halt if AL is 0
    int 0x10                ;           BIOS interrupt 10h provides video services. See https://en.wikipedia.org/wiki/INT_10H. This combined with AH and AL will display welcome text on tty screen
    jmp .startLoop

halt:
    cli                     ;           Clear interrupt flag
    hlt                     ;           Halt execution

stage1Welcome: db "Stage 1 complete!",13,0

times 510 - ($-$$) db 0x00  ;           pad remaining bytes with 0
dw 0xAA55                   ;           Magic bootloader number - Byte 511 and 512 are expected to contain 55 and AA
