[bits 16]
[global _start]

org 0x7c00								; set origin to smthn idk someone recommanded it

_start:
	mov [BOOT_DRIVE], dl				; BIOS stores the boot drive at dl
	mov bp, 0x8000						; make sure the stack is safe at 0x8000
	mov sp, bp

	mov bx, 0x9000						; load to adress 0x0000 (ES): 0x9000 (BX)
	mov dh, 5 							; 5 sectors
	mov dl, [BOOT_DRIVE]				; from the boot disk
	call disk_load

	mov dx, [0x9000]
	mov [buffer], dx

	mov dx, [0x9000+2]
	mov [buffer+2], dx

	mov dx, [0x9000+512]
	mov [buffer+4], dx

	mov dx, [0x9000+514]
	mov [buffer+6], dx

	push buffer
	call print

	push eop
	call print

	jmp $								; end of program (loop forever)

%include "./print_function.asm"			; include the print function I wrote
%include "./print_hex.asm"
%include "./disk_load.asm"

;globals
buffer: times 16 db 0
eop: db 0xa, "End of program", 0
BOOT_DRIVE: db 0 						; save the BOOT_DRIVE here

times 510-($-$$) db 0					; fill dead space with 0
db 0x55, 0xaa							; end boot sector with 0x55 0xaa
%include "./disk.asm"