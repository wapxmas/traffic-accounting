;;al_by_port_name;
	sub	ecx,ecx
    .lp:
	mov	esi,al_by_port_name_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_AL_BY_PORT_NAME
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_al_by_port_name
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_al_by_port_name:
	lodsb
	cmp	al,MAXPC_AL_BY_PORT_NAME
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	
    .next:
	mov	edi,dword[name_deny_addr]
	call	strcmp
	jecxz	.nx    
	;;;
	ret
    .nx:
	lodsd
	push esi
	  mov bl,al
	  call gp_by_proto
	pop esi
	call QallowPort
	test byte[QallowPort.fl],1
	jnz .ex
	setz byte[some_f_name_deny]
    .ex:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	