[bits 16]
printString_16:
    pusha
    mov ah, 0x0E        ;BIOS subfunction
    mov bx, 0x0007      ;BH - Page Number / BL - Text Color

nextChar_16:
    cmp byte [si], 0    ;Compare si to 0
    je stringReturn_16

    mov al, byte [si]   ;Move the character to print into al
    int 0x10

    add si, 1           ;Move forward to the next character
    jmp nextChar_16

stringReturn_16:
    mov ah, 0x0E        ;Return to a new line
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10
    popa
    ret