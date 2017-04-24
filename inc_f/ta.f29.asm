;;al_by_proto_itype();
	sub	ecx,ecx
    .lp:
	mov	esi,al_by_proto_itype_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_AL_BY_PROTO_ITYPE
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_al_by_proto_itype
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_al_by_proto_itype:
	lodsb
	cmp	al,MAXPC_AL_BY_PROTO_ITYPE
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.nx	
	call QallowSN
	test byte[QallowSN.fl],1
	jnz .nx
	setz byte[some_f_call_deny]
    .nx:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	