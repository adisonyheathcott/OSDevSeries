[bits 16]				; Tells the assembler this is 16-bit code
[org 0x7c00]			; Tells the assembler it will be in memory at 0x7c00

mov bp, 0x9000			; Set the base pointer at 0x9000
mov sp, bp				; Set the stack pointer at the base

mov si, MSG_REAL_MODE	; Move the pointer to the first character to si
call printString_16		; Call the print string function

jmp $					; Endlessly jump on this line of code

; Print String Function
printString_16:
	pusha				; Push all the registers to the stack
	mov ah, 0x0E		; BIOS Subfunction
	mov bx, 0x0007		; BH - Page Number / BL - Text Color

nextChar_16:
	cmp byte[si], 0		; Compare si to 0 (End of string delimeter)
	je stringReturn_16  ; Jump if compare is equal

	mov al, byte [si] 	; Move the character to print into al
	int 0x10			; Print Interrupt

	add si, 1			; Move forward to the next character
	jmp nextChar_16		; Jump back to print the next character in the string

stringReturn_16:
	mov al, 0x0D		; Move the ASCII code for Carraige Feed into al
	int 0x10			; Print the character
	mov al, 0x0A		; Move the ASCII code for Line Feed into al
	int 0x10			; Print the character
	popa				; Pop all the registers from the stack
	ret					; Return from the function

; Our message we want to print
MSG_REAL_MODE: db "Starting up in 16-bit Real Mode.", 0

; Fill the end of the file until 510 bytes are filled
times 510-($-$$) db 0
dw 0xaa55