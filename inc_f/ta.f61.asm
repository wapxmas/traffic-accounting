;;func_alo_ip_global;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_ip_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_IP_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_ipg
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_ipg:
	lodsb
	cmp	al,MAXPC_ALO_IP_GLOBAL
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	setnz	byte[.st]
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
