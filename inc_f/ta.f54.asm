;;deny_ip_ptype_iname;
	sub	ecx,ecx
    .lp:
	mov	esi,deny_ip_ptype_iname_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_DENY_IP_PTYPE_IN
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_deny_ip_ptypein
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_deny_ip_ptypein:
	lodsb
	cmp	al,MAXPC_DENY_IP_PTYPE_IN
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
	jc .nx
	movzx ebx,byte[packet.ptype]
	call typeexists
	or	bh,bh
	jz	.nx
	setnz	byte[some_f_name_deny]
    .nx:	
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>