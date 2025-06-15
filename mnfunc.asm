.8086
.model small
.stack 100h
.data
	cadena db "Escoja una opcion",0dh,0ah,24h
	cadena1 db "1) Leer texto",0dh,0ah,24h
	cadena2 db "2) Lee 1 Caracter y lo pasa a decimal (000-255)",0dh,0ah,24h
	cadena3 db "3) Lee 8 caracteres binarios (1 nro de 8 bits)",0dh,0ah,24h
	cadena7 db "3) SALIR",0dh,0ah,24h
;--------------------------------------------
	imprimo db "1) Imprime ",0dh,0ah,24h
	impresion1 db "A) Texto ingresado ",0dh,0ah,24h
	impresion2 db "B) Cantidad de caracteres del texto ingresado ",0dh,0ah,24h
	impresion3 db "C) Numero o binario leido (en decimal) ",0dh,0ah,24h
	vuelvoC db "2) Volver a cargar ",0dh,0ah,24h
;--------------------------------------------
	longitud db 0 ,24h
	Ascii db '000',0dh,0ah,24h
	espacio db "",0dh,0ah,24h
;-------------------------------------------
	cartelitoDc db "Ingrese el caracter deseado en decimal: ",24h
	nroAscii  db '000',0dh,0ah,24h
;-------------------------------------------
	txt db 255 dup (24h), 0dh,0ah,24h
	cartelito db "Ingrese su texto: ",24h
;---------------------------------------------
	bin     db "00000000",0dh, 0ah, 24h
    decimal db "000",0dh, 0ah, 24h
    cartel  db "Ingrese un Nro binario de 8 bits", 0dh,0ah, 24h
;---------------------------------------------

.code

extrn leotxt:proc
extrn leodec:proc
extrn largo:proc

	main proc

		mov ax, @data
		mov ds, ax

	MenuPrincipal:

		mov ah, 9
		mov dx, offset espacio
		int 21h

		mov ah, 9
		mov dx, offset cadena
		int 21h

		mov ah, 9
		mov dx, offset cadena1
		int 21h

		mov ah, 9
		mov dx, offset cadena2
		int 21h

		mov ah, 9
		mov dx, offset cadena3
		int 21h

		mov ah, 1
		int 21h

		mov ah, 9
		mov dx, offset espacio
		int 21h

		cmp al, 31h
		je Opcion1
		cmp al, 32h
		je Opcion2
		cmp al, 33h
		je Opcion3
		jmp MenuPrincipal
	Opcion1:

			mov ah, 9
			mov dx, offset cartelito
			int 21h

			mov dx, offset txt
			call leotxt

		jmp MenuSecundario

	Opcion2:

		mov ah, 9
		mov dx, offset cartelitoDc
		int 21h

		mov byte ptr nroAscii[0], '0'
		mov byte ptr nroAscii[1], '0'
		mov byte ptr nroAscii[2], '0'

		mov bx, 0

		mov ah, 1
		int 21h
		mov bl, al ; guardo el valor numerico en bl

		mov dl, bl ; mando el valor numerico a convertir
		xor dh, dh ; limpio la parte alta del registro
		push dx ;paso 1 parametro
		mov dx, offset nroAscii
		push dx ;paso 2 parametro
		call leodec

		jmp MenuSecundario


	Opcion3:

		deNuevo:
			    mov ah, 9
			    mov dx, offset cartel
			    int 21h

			;CAJA DE CARGA BINARIA CON CHEQUEO
			    mov bx, 0
			    mov cx, 8
			carga3:  
			    mov ah, 1
			    int 21h
			    cmp al, 30h
			    je TodoOk
			    cmp al, 31h
			    jne deNuevo

			TodoOk:
			    mov bin[bx], al
			    inc bx
			    loop carga3

			;FIN CAJA

			;CONVERSION ASCII TO BIN en REGISTRO
			    xor ax, ax                  ;Limpio Registro para guardar valor en binario
			    mov cx, 8                   ;Cargo en CX la cantidad de conversiones a realizar
			    lea bx, bin                 ;guardo en bx, el offset de la variable que contiene el binario en ascii

			conversion:
			    cmp cx,0
			    je r2ascii2
			    cmp byte ptr [bx], 30h      ;Comparo el contenido de bx (variable bin) con 0 en ascii
			    je esCero                   ;si es 30h salto a esCero
			    shl al, 1                   ;shifteo por izquierda (inserto un 0 por derecha)
			    inc al                      ;incremento en 1 para que quede el uno en la posición
			continua:
			    inc bx                      ;incremento bx para analizar el siguiente valor
			    dec cx

			    jmp conversion              ;loop de trabajo.

			esCero:
			    shl al, 1                   ;si es 0 solo shifteo porque ingreso un 0 por derecha
			    jmp continua

			;FIN CONVERSION


			;CONVERSION DE REG A ASCII
			        ;EL PROCESO ANTERIOR GUARDO EN AL EL VALOR A CONVERTIR
			r2ascii2:

				mov byte ptr decimal[0], '0'
				mov byte ptr decimal[1], '0'
				mov byte ptr decimal[2], '0'

			    mov bl, al ; guardo el valor numerico en bl

				mov dl, bl ; mando el valor numerico a convertir
				xor dh, dh ; limpio la parte alta del registro
				push dx ;paso 1 parametro
				mov dx, offset decimal
				push dx ;paso 2 parametro
				call leodec


	    jmp MenuSecundario

	Salir:
		jmp afuera

	MenuSecundario:

		mov ah, 9
		mov dx, offset espacio
		int 21h

		mov ah, 9
		mov dx, offset imprimo
		int 21h

		mov ah, 9
		mov dx, offset vuelvoC
		int 21h

		mov ah, 9
		mov dx, offset cadena7
		int 21h
		
		mov ah, 1
		int 21h

		mov ah, 9
		mov dx, offset espacio
		int 21h

		cmp al, 31h
		je print
		cmp al, 32h
		je vuelvomenu
		cmp al, 33h
		je Salir
		jmp MenuSecundario

	vuelvomenu:
		jmp MenuPrincipal

	print:

		mov ah, 9
		mov dx, offset espacio
		int 21h

		mov ah, 9
		mov dx, offset impresion1
		int 21h

		mov ah, 9
		mov dx, offset impresion2
		int 21h

		mov ah, 9
		mov dx, offset impresion3
		int 21h
		
		mov ah, 1
		int 21h

		mov ah, 9
		mov dx, offset espacio
		int 21h

		cmp al, "a"
		je print1
		cmp al, "b"
		je print2
		cmp al, "c"
		je print3
	jmp print

	print1:
		mov ah, 9
		mov dx, offset txt
		int 21h
	jmp MenuSecundario

	print2:
		mov byte ptr longitud, 0

		mov dx, offset txt
		push dx
		mov dx, offset longitud
		push dx
		mov ah, 20h
		call largo

		;convierto a ascii

		mov byte ptr Ascii[0], '0'
		mov byte ptr Ascii[1], '0'
		mov byte ptr Ascii[2], '0'

		mov bl, byte ptr longitud ; guardo el valor numerico en bl

		mov dl, bl ; mando el valor numerico a convertir
		xor dh, dh ; limpio la parte alta del registro
		push dx ;paso 1 parametro
		mov dx, offset Ascii
		push dx ;paso 2 parametro
		call leodec

		;imprimo cantidad ahora

		mov ah, 9
		mov dx, offset Ascii
		int 21h

	jmp MenuSecundario	

	print3:
		mov ah, 9
		mov dx, offset espacio
		int 21h

		mov ah, 9
		mov dx, offset nroAscii
		int 21h

		mov ah, 9
	   	mov dx, offset espacio
	    int 21h

	    mov ah, 9
	    mov dx, offset decimal
	    int 21h
	jmp MenuSecundario

	afuera:

		mov ax, 4c00h
		int 21h

	main endp

end