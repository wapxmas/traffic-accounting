;;bin_full_stat_by_ip_global();
	sub	ecx,ecx
    .lp:
	mov	esi,bin_full_stat_by_ip_global_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_BIN_FULL_STAT_BY_IP_GLOBAL
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_full_bin_stat_big
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_full_bin_stat_big:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_BIN_FULL_STAT_BY_IP_GLOBAL
	jz	.nex_1
	sub	al,(MAXPC_BIN_FULL_STAT_BY_IP_GLOBAL-1)
	jz	.next
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipIP
	mov	dword[file_estart], esi
	call	NSkipFile
	call	NSkipEnum
	
	mov	dword[name_deny_addr],esi
	pop	esi
	mov	dword[some_f_name_deny],0
	mov	esi,dfuncs_ntable
	call	run_f
	test	dword[some_f_name_deny],1
	jz	.next
	;;;
	ret	
    .next:
	mov	esi,dword[name_esi_tmp]
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
	jnz	.ipa
	;;;
	ret
.st	db	0
    .ipa:
	lodsd
	mov	dword[.fd],eax
	call	to_zero
	movzx	ebx,byte[packet.ptype]
	call	typeexists
	or	bh,bh
	jz	.ex
	mov	edi,stat_buffer.s3
	call	add_bin_fgstat
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s3
	call	add_traffic
    .ex:	
	;;;
	ret
.fd	dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	