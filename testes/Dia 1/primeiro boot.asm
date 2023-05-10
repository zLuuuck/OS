[ORG 0x7c00]          ; set initial addres

LOOP:
	jmp LOOP
times 510-($-$$) db 0

db 0xAA
db 0x55