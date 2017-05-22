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
     	movi r1, 9 
    	movi r2, 4 
	movi r1, 0x00
    	movhi r1, 0x70
	ld r3, 0(r1) 
	movi r3, 5
	add r3,r3,r3
  	halt

  .org 0x1000
 
RSG:    $PUSH r0, r1, r2, r3, r4, r5, r6 ;salvamos el estado en la pila
		
	rds r3, s2 ;     
        movi   r1, 7                     ;Mira si es de MISS TLBD
        cmpeq  r2, r1, r3
        bz    r2, no
  	out     5, r1			 ;Ha de salir un 6 por el HEX0, codigo excepcion de MISS TLBI
no:     $POP r6, r5, r4, r3, r2, r1, r0  ;restauramos el estado desde la pila (ojo orden inverso)
        reti
