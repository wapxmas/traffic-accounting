;;deny_ip_in_name;
	sub	ecx,ecx
    .lp:
	mov	esi,deny_ip_in_name_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_DENY_IP_IN_NAME
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_deny_ipinn
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_deny_ipinn:
	lodsb
	cmp	al,MAXPC_DENY_IP_IN_NAME
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
	jz	.nx
	setnz	byte[some_f_name_deny]
    .nx:	
	;;;
	ret
.st	db	0
;;esi=enum;
NSkipEnum:
	lodsb
	movzx ecx,al
    .lp:
	call to_zero
	dec ecx
	jnz	.lp
	;;;
	ret
;;esi=enumIP;
NSkipIP:
	lodsb
	movzx edx,al
    .lp:
	lodsb
	test al,IPTYPE_MASK
	jnz .mask
	test al,IPTYPE_RANGE
	jz .nx1
		lodsb
		movzx ebx,al
		mov ecx,8
		sub eax,eax
	    .cbits: rcr ebx,1
		    jnc	.nxc
		    inc eax
	    .nxc:
	    	    dec ecx
		    jnz .cbits
	    lea esi,[esi+eax+4]
	    jmp short .nx
    .mask:
	 lodsd
    .nx1:
	lodsd
    .nx:
	dec edx
	jnz .lp
	;;;
	ret
;;esi=*struct_file;
NSkipFile:
	lea esi,[esi + 4]
	call to_zero
	;;;
	ret
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>