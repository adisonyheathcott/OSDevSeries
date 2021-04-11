[bits 16]
[org 0x9000]

; Store the boot drive
mov [BOOT_DRIVE], dl

; Load a message and print
mov si, SECOND_BOOT_MSG
call printString_16

jmp $

; Includes
%include "printString_16.asm"

BOOT_DRIVE: db 0
SECOND_BOOT_MSG: db "The second bootloader has been loaded!", 0