;;alo_dev_in_name;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_dev_in_name_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_DEV_IN_NAME
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_devinn
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_devinn:
	lodsb
	cmp	al,MAXPC_ALO_DEV_IN_NAME
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
	movzx	ebx,al
    .lpf:
	mov	edi,packet.dev
	call	strcmp
	jecxz	.quit
	call	to_zero
	dec	ebx
	jnz	.lpf
	setz	byte[some_f_name_deny]
    .quit:
	;;;
	ret
