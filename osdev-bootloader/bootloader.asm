[bits 16]
[org 0x7c00]

mov [BOOT_DRIVE], dl

mov bp, 0x8FFF
mov sp, bp

mov si, MSG_REAL_MODE
call printString_16

loadSecondBoot:
    ; SI - offset to the disk address packet
    mov si, LBA_SECONDBOOT
    ; AH - The subroutine for 0x13 - Extended read from disk
    mov ah, 0x42
    ; DL - Boot drive
    mov dl, [BOOT_DRIVE]

    ; Interrupt
    int 0x13
    jc diskReadFailed

    jmp SECONDBOOT_OFFSET

diskReadFailed:
    mov si, ERROR_MSG
    call printString_16
    jmp $

%include "printString_16.asm"

SECONDBOOT_OFFSET: equ 0x9000
BOOT_DRIVE: db 0

LBA_SECONDBOOT:
    ; Size of DAP
    db 0x10
    ; Unused
    db 0x00
    ; Number of sectors to be read
    dw 0x01
    ; Offset to the loaded location -x86 (little endian)
    dw SECONDBOOT_OFFSET
    dw 0x00
    ; Absolute number of the start sector to be read
    dd 0x01
    dd 0x00

MSG_REAL_MODE: db "Starting up in 16-bit Real Mode.", 0
ERROR_MSG: db "Error reading from disk.", 0

times 510-($-$$) db 0
dw 0xaa55