[ORG 0x7c00] ;endereço inicial da memória

mov AH, 2   ;Comando para ler o disco que originou o boot
mov AL, 1   ;Total de setores lidos
mov CH, 0   ;Número do cilíndro
mov CL, 2   ;Número do setor para começar a ler
mov DH, 1   ;Número da cabeça a ser lida
mov ES, [EXTENSION]
mov BX, 0
int 13h
jmp PRINT_STR

STR: db 'Ola mundo! Primeiro texto na tela.', 13,10,0

times 510-($-$$) db 0

;Assinatura pro boot funcionar
dw 0xAA55
;--------------------------------------------------------------
EXTENSION:
    mov AH, 0x00    ;Tipo de função: Definir modo de video
    mov AL, 0x13    ;Modo de video
    int 0x10        ;Interrupção de video
    mov AL, 0x01    ;Cor do pixel
    mov BH, 0x00    ;Número da página
    mov CX, 0x00    ;Posição X
    mov DX, 0x00    ;Posição y

LOOP:
	mov AH, 0x0C    ;Função: Escrever pixel na tela
    int 0x10        ;Interrução de vídeo
	inc CX          ;Avança para o pixel a direita
	cmp CX, 0x0140  ;Verificia se é igual 320 (limite)
	jne LOOP        ;Se não for igual, continua o ciclo
	mov CX, 0x00    ;Volta para a posição 0
	inc DX          ;Avança para a próxima linha
	cmp DX, 0xC8    ;Verifica se é igual a 200 (limite)
	jne LOOP        ;Se não for igual, continua o ciclo
	mov DX, 0x00    ;Volta para a primeira linha
	inc AL          ;Pula para a próxima cor
	cmp AL, 0xFF    ;Verifica se é 255 ou -1 (última cor)
	je RESETCOR     ;Se é a última cor, volta para a primeria
	jmp LOOP 

RESETCOR:           ;Reseta a cor
	mov AL, 0x00    ;Reinicia para a primeira cor
	jmp LOOP

PRINT_STR:
    xor AX, AX      ;Zera o acumulador
    mov DS, AX 
    mov SI, STR

CHAR_LOOP: lodsb 
    or AL, AL       ;Verifica se o valor não tem valor 0
    jz HANG         ;Fica em loop até desligar o computador
    mov AH, 0x0E    ;Seleciona a interrupção a ser executada
    int 0x10        ;Executa a rotina de video selecionado
    jmp CHAR_LOOP   ;Vai para o próixmo caractere
    
HANG:
    jmp HANG