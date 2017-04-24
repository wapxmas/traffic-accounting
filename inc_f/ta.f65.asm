;;func_alo_dev;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_dev_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_DEV
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_dev
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_dev:
	lodsb
	cmp	al,MAXPC_DENY_DEV
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
	mov	dword[some_f_call_deny],1
	;;;
	ret
    .log:	
	;;;
	ret
