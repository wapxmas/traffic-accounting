;;al_only_proto_global();
	sub	ecx,ecx
    .lp:
	mov	esi,al_only_proto_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_AL_ONLY_PROTO_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_al_only_proto_global
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
    ;;;
    ret
do_al_only_proto_global:
	lodsb
	cmp	al,MAXPC_AL_ONLY_PROTO_GLOBAL
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	call QallowSN
	test byte[QallowSN.fl],1
	jnz .nx
	setz byte[some_f_call_deny]
    .nx:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	