;;bin_stat_by_ip_dev();
	sub	ecx,ecx
    .lp:
	mov	esi,bin_stat_by_ip_dev_buffer
	lodsd
	dec	eax
	imul	ebx,ecx,MAXL_BIN_STAT_BY_IP_DEV
	add	esi,ebx
	    push ecx
		push	eax
	    	    call do_bin_stat_bid
		pop	eax
	    pop ecx
	inc	ecx
	cmp	ecx,eax
	jna	.lp
	;;;
	ret
do_bin_stat_bid:
	lodsb
	mov	dword[name_esi_tmp],esi
	cmp	al,MAXPC_BIN_STAT_BY_IP_DEV
	jz	.nex_1
	sub	al,(MAXPC_BIN_STAT_BY_IP_DEV-1)
	jz	.next	
	mov	eax,err_sPC
	call	write
	call	@exit	    
    .nex_1:
    	test	byte[dfuncs_ntable.ex],1
	jz	.next
	push	esi
	call	NSkipEnum	
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
	call	add_bin_gstat	
	mov	edx,ecx
	mov	ebx,dword[.fd]
	mov	ecx,stat_buffer.s3
	call	add_traffic
    .ex:	
	;;;
	ret
.fd	dd	0
;Copyright (C) 2002 Yashin Sergey <yashin.sergey@gmail.com>	