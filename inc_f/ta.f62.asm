;;func_alo_ip_in_type;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_ip_in_type_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_IP_IN_TYPE
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_ipint
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_ipint:
	lodsb
	cmp	al,MAXPC_ALO_IP_IN_TYPE
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.nx
	setz	byte[.st]
	lodsb
	movzx	ecx,al	
    .lp:
	push	ecx
	call	Qallow_ip
	jc	.ce
	setnc	byte[.st]
    .ce:
	pop	ecx
	dec	ecx
	jnz	.lp
	test	byte[.st],1
	jnz	.nx
	setz	byte[some_f_call_deny]
    .nx:
	;;;
	ret
.st	db	0
