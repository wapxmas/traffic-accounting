;;func_alo_ip_in_name;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_ip_in_name_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_IP_IN_NAME
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_ipinn
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_ipinn:
	lodsb
	cmp	al,MAXPC_ALO_IP_IN_NAME
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
	lodsb
	movzx	ecx,al
	mov	byte[.st],0
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
	setz	byte[some_f_name_deny]
    .nx:	
	;;;
	ret
.st	db	0
