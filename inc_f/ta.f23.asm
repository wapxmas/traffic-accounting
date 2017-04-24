;;al_by_port_global;
	sub	ecx,ecx
    .lp:
	mov	esi,al_by_port_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_AL_BY_PORT_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_al_by_port_global
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_al_by_port_global:
	lodsb
	cmp	al,MAXPC_AL_BY_PORT_GLOBAL
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	
    .next:
	lodsd
	cmp al,byte[packet.ipproto]
	jz .nx
	;;;
	ret
    .nx:
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi
	call QallowPort
	test byte[QallowPort.fl],1
	jnz .ex
	setz byte[some_f_call_deny]
    .ex:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	