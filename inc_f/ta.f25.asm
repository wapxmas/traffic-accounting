;;rs_by_port_itype;
	sub	ecx,ecx
    .lp:
	mov	esi,rs_by_port_itype_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_RS_BY_PORT_ITYPE
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_rs_by_port_itype
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_rs_by_port_itype:
	lodsb
	cmp	al,MAXPC_RS_BY_PORT_ITYPE
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	
    .next:
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.ex
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
	jz .ex
	setnz byte[some_f_call_deny]
    .ex:
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	