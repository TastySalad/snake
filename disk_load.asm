disk_load:
	.prepare:							; wanted to use popa here but it messes with the results
		push dx

	.read_routine:
		mov ah, 0x02					; BIOS read sector instruction

		mov al, dh						; read the amount of sectors requested
		mov ch, 0x00					; read from cylinder 0
		mov dh, 0x00					; select head 0
		mov cl, 0x02					; start reading from the 2 sector i.e after the boot sector

		int 0x13						; call interrupt

	.check_error:
		jc .disk_error					; jump to disk error if the error flag (carry flag) is raised

		pop dx							; restore the original value to dx
		cmp dh, al  					; check that if we have the sectors we expect
		jne .disk_error
		ret

	.disk_error:
		push DISK_ERROR_MSG
		call print
		push ax							; ah-return code al-number of sectors read
		call print_hex
		jmp $

DISK_ERROR_MSG: db "Disk read error! Error Code (AX reg): ", 0