print:									; function to print an null terminated string from stack
	.prepare:
		push bp
		mov bp, sp

		pusha							; save all registers

		mov si, [bp+4]					; use si so save index of string		

	.char_loop:
		mov al, [si]					; offset from added data
		add si, 1

		cmp al, 0x0						; string is terminated by null
		je .return

		mov ah, 0x0e
		int 0x10

		jmp .char_loop

	.return:							; pop back out all registers
		popa
		pop bp
		ret