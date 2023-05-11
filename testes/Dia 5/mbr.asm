[ORG 0x7c00] ;endereço inicial da memória

times 510-($-$$) db 0

;Assinatura pro boot funcionar
db 0x55
db 0xAA