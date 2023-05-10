[ORG 0x7c00] ;endereço inicial da memória
; Definindo o modo de Vídeo
	mov AH, 0x00 ; Tipo de função
	mov AL, 0x13 ; Em decimal: 19
	int 0x10 ; Interrupção 10
; Parâmetros utilizados
	mov AL, 0x01 ; Cor do pixel
	mov BH, 0x00 ; Definição da página (número)
	mov CX, 0x00 ; Uso geral de armazenagem de valores, vai armazenar a posição X do pixel, da esquerda para a direita
	mov DX, 0x00 ; Respectivamente, armazena o valor Y da posição do pixel

;Lógica para desenhar na tela todas as cores
LOOP:
	mov AH, 0x0C ;Numa determinada posição, grava um pixel de uma determinada cor
	int 0x10 ;chama a função de video 
	inc CX ;avança para o pixel a direita
	cmp CX, 0x0140 ;verifica se igual a 320
	jne LOOP ; se não for igual, continua, se não, volta
	mov CX, 0x00 ;reinicia a posição de X
	inc DX ; Avança para a próxima linha
	cmp DX, 0xC8 ;Verifica se já no limite inferior (200px)
	jne LOOP ; se não for igual a 200, volte para o loop, se não, continue
	mov DX, 0x00 ;volta para a primeira linha
	inc AL ; próxima cor
	cmp AL, 0xFF ;Comparação com o limite de cor (FF de HEX para DEC é = -1 ou 255, dependendo do modo)
	je RESETCOR; Se já estiver no limite, ele reseta
	jmp LOOP ; salto incondicional para o loop
RESETCOR: ; Reseta a cor
	mov AL, 0x00
	jmp LOOP
times 510-($-$$) db 0

;Assinatura pro boot funcionar
db 0x55
db 0xAA

