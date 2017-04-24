;;al_by_proto_name();
	sub	ecx,ecx
    .lp:
	mov	esi,al_by_proto_name_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_AL_BY_PROTO_NAME
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_al_by_proto_name
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_al_by_proto_name:
	lodsb
	cmp	al,MAXPC_AL_BY_PROTO_NAME
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit
    .next:
	mov	edi,dword[name_deny_addr]
	call	strcmp
	jecxz	.next1
	;;;
	ret
    .next1:
	call QallowSN
	test byte[QallowSN.fl],1
	jnz .nx
	setz byte[some_f_name_deny]
    .nx:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	