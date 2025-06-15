.8086
.model small
.stack 100h
.data
	
	dataDiv	db 100,10,1

.code

	public leotxt

	public leodec

	public largo

	largo proc
	;Esta funcion lee el largo del texto por stack ss:[bp+6] y una para la cantidad ss:[bp+4]
			push bp
			mov bp, sp 
			push bx
			push si

			mov bx, ss:[bp+6]
			mov si, ss:[bp+4]

		cuentomenos:
			cmp byte ptr[bx], 24h
			je finCuento
			cmp byte ptr[bx], ah
			je incrementoValor
				
			inc byte ptr [si]
			inc bx
		jmp cuentomenos

		incrementoValor:
			inc bx
		jmp cuentomenos

		finCuento:
			pop si
			pop bx
			pop bp

		ret 4
	largo endp


	leotxt proc
	;esta funcion lee el texto enviado por dx
	;y lo devuelve cargado por bx 
			push dx
			push bx
			push ax

			mov bx, dx

			cargaFunc:
				mov ah, 1 
				int 21h
				cmp al, 0dh 
				je finCarga9
				mov [bx], al
				inc bx
			jmp cargaFunc

			finCarga9:

				mov byte ptr [bx], 24h

			pop ax
			pop bx
			pop dx
		ret
	leotxt endp

	leodec proc
	;esta funcion hace un reg2ascii
			push bp
			mov bp, sp

			push ax
			push si
			push bx
			push cx
			push dx

			mov ax, ss:[bp+6] ;guardo el valor
			mov si, ss:[bp+4] ;guardo la direccion del nro ascii
			lea bx, dataDiv   ;mov bx, offset dataDiv

			mov cx, 3
		aca:
			mov dl, [bx]
			div dl			  ;divido por 100
			add [si], al 	  ;guardo dato

			inc bx
			inc si
			mov al, ah
			xor ah, ah
		loop aca
			

			pop dx
			pop cx
			pop bx
			pop si
			pop ax
			pop bp

		ret 4
	leodec endp

end