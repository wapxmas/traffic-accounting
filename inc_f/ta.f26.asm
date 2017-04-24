;;rs_by_proto_itype();
	sub	ecx,ecx
    .lp:
	mov	esi,rs_by_proto_itype_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_RS_BY_PROTO_ITYPE
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_rs_by_proto_itype
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
    ;;;
    ret
do_rs_by_proto_itype:
	lodsb
	cmp	al,MAXPC_RS_BY_PROTO_ITYPE
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
	jz .nx
	setnz byte[some_f_call_deny]
    .nx:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	