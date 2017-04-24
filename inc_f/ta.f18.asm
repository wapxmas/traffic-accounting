;;rs_by_proto_idev();
	sub	ecx,ecx
    .lp:
	mov	esi,rs_by_proto_idev_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_RS_BY_PROTO_IDEV
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_rs_by_proto_idev
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
    ;;;
    ret
do_rs_by_proto_idev:
	lodsb
	cmp	al,MAXPC_RS_BY_PROTO_IDEV
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	lodsb
	movzx	ebx,al
    .lp:
	mov	edi,packet.dev
	call	strcmp
	jecxz	.do_rsi
	call	to_zero
	dec	ebx
	jnz	.lp
	;;;
	ret
 .do_rsi:
	dec	ebx
	jz	.nxl
	    .lp2:
		call to_zero
		dec	ebx
		jnz	.lp2
    .nxl:
	call QallowSN
	test byte[QallowSN.fl],1
	jz .nx
	setnz byte[some_f_call_deny]
    .nx:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	