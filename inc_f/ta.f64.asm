;;func_alo_ip_in_dev;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_ip_in_dev_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_IP_IN_DEV
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_ipind
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_ipind:
	lodsb
	cmp	al,MAXPC_ALO_IP_IN_DEV
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .next:
	lodsb
	movzx	ebx,al
    .lpf:
	mov	edi,packet.dev
	call	strcmp
	jecxz	.log
	call	to_zero
	dec	ebx
	jnz	.lpf
	;;;
	ret
    .log:
	dec	ebx
	jz	.nxl
	    .lp2:
		call to_zero
		dec	ebx
		jnz	.lp2
    .nxl:    
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
	setz	byte[some_f_call_deny]
    .nx:
	;;;
	ret
.st	db	0
