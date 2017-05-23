
.include "macros.s"


.set PILA, 0x2000               ;una posicion de memoria de una zona no ocupada para usarse como PILA i QUE ESTA EN TLB


.text
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        ; Inicializacion
        ; *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
        $MOVEI r1, RSG
        wrs    s5, r1      ;inicializamos en S5 la direccion de la rutina de antencion a la interrupcion
        $MOVEI r7, PILA    ;inicializamos R7 como puntero a la pila

	;Ahora empieza el codigo, no hacemos jmp, sino directo
        
	movi   r1, 0xF
        out     9, r1              ;activa todos los visores hexadecimales
  	; 0x3d = 11_1100 (v=1,r=1,marco=12, C) 
  	movi r1, 0x3C 
  	movi r2, 4 
  	wrpd r2, r1   ; Escribe la misma pagina fisica en la misma virtual pero con el read only a '1'
	movi r1, 0x00
    	movhi r1, 0xC0
	st  0(r1),r6 ; hace un store a una posicion que no puede tendria que saltar excepcion
	movi r3, 5
	add r3,r3,r3
  	halt

  .org 0x1000
 
RSG:    $PUSH r0, r1, r2, r3, r4, r5, r6 ;salvamos el estado en la pila
		
	rds r3, s2 ;     
        movi   r1, 12                     ;Mira si es es Excepcio read only
        cmpeq  r2, r1, r3
        bz    r2, no
  	out     5, r1			 ;Si es, OUT
no:     $POP r6, r5, r4, r3, r2, r1, r0  ;restauramos el estado desde la pila (ojo orden inverso)
        reti
