;;func_alo_ip_ptype_iname;
	sub	ecx,ecx
    .lp:
	mov	esi,alo_ip_ptype_iname_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_ALO_IP_PTYPE_IN
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_alo_ip_ptypein
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_alo_ip_ptypein:
	lodsb
	cmp	al,MAXPC_ALO_IP_PTYPE_IN
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
	call cIPcheck
	setnc byte[.eq]
	movzx ebx,byte[packet.ptype]
	call typeexists
	or	bh,bh
	jz	.nx
	test	byte[.eq],1
	jnz	.nx
	setz	byte[some_f_name_deny]
    .nx:	
	;;;
	ret
.eq	db	0